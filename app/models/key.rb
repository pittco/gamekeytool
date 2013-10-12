class Key < ActiveRecord::Base
  attr_accessible :claimed_by, :keystring

  def self.for claimant
    key = Key.where claimed_by: claimant
    if key.size == 0
      nil
    else
      key.first
    end
  end

  def self.unclaimed
    keys = Key.where claimed_by: nil
    if keys.size == 0
      []
    else
      keys
    end
  end
end
