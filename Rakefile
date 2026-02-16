require 'dotenv/load'
require "tempfile"

s3_bucket_name = ENV['AWS_S3_BUCKET_NAME']
aws_region= ENV['AWS_REGION']
access_key = ENV['AWS_ACCESS_KEY_ID']
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

desc "Setup the S3 bucket"
task :setup_bucket do
  # NOTE: add the bucket to the policy of the user

  sh "aws s3api create-bucket --bucket \"#{s3_bucket_name}\" --region \"#{aws_region}\" --create-bucket-configuration LocationConstraint=\"#{aws_region}\""
  sh "aws s3 website \"s3://#{s3_bucket_name}/\" --index-document index.html --error-document 404.html"

  # # Allow public access for the bucket
  sh "aws s3api put-public-access-block --bucket \"#{s3_bucket_name}\" --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

  Tempfile.create(["bucket_policy", ".json"]) do |f|
    f.write <<~JSON
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::#{s3_bucket_name}/*"
          }
        ]
      }
    JSON
    f.flush

    sh "aws s3api put-bucket-policy --bucket \"#{s3_bucket_name}\" --policy file://#{f.path}"
  end

  puts "👉 http://#{s3_bucket_name}.s3-website.#{aws_region}.amazonaws.com"
end

desc "Remove all files from the build directory"
task :clean do
  sh 'rm -rf ./build'
end

desc "Compile the sitepress site"
task :compile do
  sh 'npx @tailwindcss/cli -i ./assets/stylesheets/site.source.css -o ./assets/stylesheets/site.css --minify'
  sh 'yarn esbuild ./assets/javascripts/site.source.js --bundle --outfile=./assets/javascripts/site.js --minify'
  sh 'bundle exec ./scripts/generate_search_index.rb'
  sh 'bundle exec sitepress compile'
  sh "mv ./build/404/index.html ./build/404.html"
  sh "rm -rf ./build/404"
  sh 'bundle exec ./scripts/generate_llm_markdown.rb'
  Rake::Task[:compile_sitemap].invoke
end

namespace :publish do
  desc "Upload ./build/assets to S3 with cache-control headers optimized for assets"
  task :assets do
    sh "aws s3 sync ./build/assets s3://#{s3_bucket_name}/assets --cache-control max-age=31536000"
  end

  desc "Upload ./build to S3"
  task :pages do
    sh "aws s3 sync ./build s3://#{s3_bucket_name} --exclude 'assets/**' --cache-control max-age=60"
  end
end

desc "Compile the sitemap"
task :compile_sitemap do
  require_relative './lib/sitemap.rb'
  Sitemap.compile(path: Dir.getwd, base_url: ENV['SITE_BASE_URL'])
end

desc "Upload pages and assets to S3"
task publish: %w[publish:assets publish:pages]

desc "Purge cache from the CDN"
task :purge_cache do
  require_relative './lib/bunnycdn.rb'

  client = Bunnycdn.new(access_key: ENV['BUNNYCDN_ACCESS_KEY'])
  client.purge(ENV['BUNNYCDN_ZONE_ID'])
end

task default: %w[clean compile publish purge_cache]
