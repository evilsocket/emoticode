ThinkingSphinx::Index.define :source, :with => :active_record do
  indexes title, :sortable => true
  indexes description
  indexes text
end
