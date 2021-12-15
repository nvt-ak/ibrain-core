# frozen_string_literal: true

module Ibrain
  # Configuration point for User model implementation.
  #
  # `Ibrain::UserClassHandle` allows you to configure your own implementation of a
  # User class or use an extension like `ibrain-auth`.
  #
  # @note Placeholder for name of Ibrain.user_class to ensure later evaluation at
  #  runtime.
  #
  #  Unfortunately, it is possible for classes to get loaded before
  #  Ibrain.user_class has been set in the initializer. As a result, they end up
  #  with class_name: "" in their association definitions. For obvious reasons,
  #  that doesn't work.
  #
  #  For now, Rails does not call to_s on the instance passed in until runtime.
  #  So this little hack provides a wrapper around Ibrain.user_class so that we
  #  can basically lazy-evaluate it. Yay! Problem solved forever.
  class UserClassHandle
    # @return [String] the name of the user class as a string.
    # @raise [RuntimeError] if Ibrain.user_class is nil
    def to_s
      fail "'Ibrain.user_class' has not been set yet." unless Ibrain.user_class

      "::#{Ibrain.user_class}"
    end
  end
end
