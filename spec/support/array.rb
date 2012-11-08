class Array
  # applies methods to elements cyclically: each element is processed by one method once
  # can take lambdas with one param, strings with %s or just strings that evaluate using `x` variable
  def map_respectively *methods
    n = methods.count
    methods = methods.map { |x| prepare_lambda x }
    each_with_index.map { |e,i| methods[i % n].(e) }
  end

  private
  # string -> lambda if needed
  def prepare_lambda given
    case given
    when String
      if given['%s']
        ->(x){ eval(given % x) }
      else
        ->(x){ eval given }
      end
    else
      given
    end
  end
end