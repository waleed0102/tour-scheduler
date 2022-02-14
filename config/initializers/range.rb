# frozen_string_literal: true

# Monkey Patch Range class to add intersection method here
class Range
  def intersection(other)
    return nil if (max < other.begin) || (other.max < self.begin)

    [self.begin, other.begin].max..[max, other.max].min
  end

  alias & intersection
end
