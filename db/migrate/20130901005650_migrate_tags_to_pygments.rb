class MigrateTagsToPygments < ActiveRecord::Migration
  def change
    Tag.delete_all
    Link.delete_all

    total = Source.count
    done  = 0

    Source.all.find_each do |s|
      s.send :lexical_analysis!

      done += 1
      if done % 100 == 0 
        puts "Done #{done}/#{total} ..."
      end
    end
  end
end
