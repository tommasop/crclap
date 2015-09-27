require "../src/crclap"

test "flag with one argument" do
  result = Crclap.run %w(-x y), { "-x" => lambda { |flag| assert flag == "y" } }
  assert result == [] of String
end

test "flag with more than one argument" do
  result = Crclap.run %w(-x y z), { "-x" => lambda { |y, z| assert [y, z] == %w(y z) } }
  assert result == [] of String
end

test "flag with wrong number of arguments" do
  assert_raise(ArgumentError) do
    Crclap.run %w(-x), { "-x" => lambda { |flag| } }
  end
end

test "extract flags with parameters" do
  result = Crclap.run %w(a b -x y c), { "-x" => lambda { |flag| assert flag == "y" } }
  assert result == %w(a b c)
end

test "extract flags with zero arity" do
  result = Crclap.run %w(a b -x c), { "-x" => lambda {} }
  assert result == %w(a b c)
end

test "extract flags with no parameters" do
  result = Crclap.run %w(a b -x c), { "-x" => lambda {} }
  assert result == %w(a b c)
end

test "use a method instead of a lambda" do
  class Foo
    def self.bar(flag)
      assert flag == "y"
    end
  end

  result = Crclap.run %w(a b -x y c), { "-x" => Foo.method(:bar) }
  assert result == %w(a b c)
end
