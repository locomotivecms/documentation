class SitePage
  attr_reader :title, :path, :order, :children, :resource
  attr_accessor :next_sibling, :parent

  def initialize(title:, path:, resource:, order: Float::INFINITY)
    @title = title
    @path = path
    @resource = resource
    @order = order
    @children = []
    @next_sibling = nil
    @parent = nil
  end

  def children?
    children.any?
  end

  def append_child(child)
    return if child.nil?

    child.parent = self
    children << child
  end

  def sort_children!
    children.sort_by!(&:order).tap do |children|
      children.each_with_index do |child, index|
        child.next_sibling = children[index + 1]
      end
    end
  end

  def self.build_from_root(root)
    parent = new(title: nil, path: nil, resource: nil)

    # add the index page which is not a child of the root
    parent.append_child(build(root, recursive: false))

    # add the first level of children
    root.children.map { parent.append_child(build(it)) }

    # sort the children (+ set the next_sibling for the first level)
    parent.sort_children!

    parent.children
  end

  def self.build(node, recursive: true)
    resource = node.resources.first
    data = resource.data
    path = resource.data['redirect_to'] ? nil : resource.request_path

    return nil if data['sidebar'] == false

    new(
      title: data.fetch("title", File.basename(resource.request_path)),
      path: path,
      resource: resource,
      order: data.fetch("order", Float::INFINITY)
    ).tap do |page|
      if recursive
        node.children.each do |child|
          page.append_child(build(child))
        end
        page.sort_children! if node.children.any?
      end
    end
  end

  def self.find(pages, resource)
    page = pages.find { |page| page.resource == resource }

    return page if page

    pages
    .map { find(it.children, resource) }
    .flatten.compact.first
  end

  def self.find_next_page(pages, resource)
    page = find(pages, resource)

    # pp "#{page.title} / parent: #{!!page.parent}, #{page.parent&.title} / next_sibling: #{page.next_sibling&.title}"

    # nominal case, check for the next sibling in the current level
    if page.next_sibling
      return page.next_sibling unless page.next_sibling.children?
      # the next sibling is a folder, return the first child
      return page.next_sibling.children.first
    end

    # if there is no next sibling, check the parent's next sibling
    return nil if page.parent.nil?

    next_parent_sibling = page.parent.next_sibling

    return nil if next_parent_sibling.nil?

    return next_parent_sibling unless next_parent_sibling.children?

    next_parent_sibling.children.first
  end
end
