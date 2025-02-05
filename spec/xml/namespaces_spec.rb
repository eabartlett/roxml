require_relative './../spec_helper.rb'

describe ROXML, "#xml_namespaces" do
  describe "for reading" do
    class Tires
       include ROXML

       xml_namespaces \
         :bobsbike => 'http://bobsbikes.example.com',
         :alicesauto => 'http://alicesautosupply.example.com/'

       xml_reader :bike_tires, :as => [], :from => '@name', :in => 'bobsbike:tire'
       xml_reader :car_tires, :as => [], :from => '@name', :in => 'alicesauto:tire'
       xml_reader :tires, :as => [], :from => '@name', :in => 'tire', :namespace => '*'
     end

    before do
       @xml = %{<?xml version="1.0"?>
         <inventory xmlns="http://alicesautosupply.example.com/" xmlns:bike="http://bobsbikes.example.com">
          <tire name="super slick racing tire" />
          <tire name="all weather tire" />
          <bike:tire name="skinny street" />
         </inventory>
       }
    end

    it "should remap default namespaces" do
      expect(Tires.from_xml(@xml).car_tires).to match_array(['super slick racing tire', 'all weather tire'])
    end

    it "should remap prefix namespaces" do
      expect(Tires.from_xml(@xml).bike_tires).to eq(['skinny street'])
    end

    context "with namespace-indifferent option" do
      it "should return all tires" do
        expect(Tires.from_xml(@xml).tires).to match_array(['super slick racing tire', 'all weather tire', 'skinny street'])
      end
    end
  end

  context "when an included namespace is not defined in the xml" do
    context "where the missing namespace is the default" do
      it "should raise"

      context "but the namespace is declared in the body" do
        it "should succeed"
      end
    end
    
    context "where the missing namespace is included in a namespacey from" do
      it "should raise"

      context "but the namespace is declared in the body" do
        it "should succeed"
      end
    end
    
    context "where the missing namespace is included in an explicit :namespace" do
      it "should raise"

      context "but the namespace is declared in the body" do
        it "should succeed"
      end
    end
  end
  describe "for writing" do
    class NamespacedNode
      include ROXML

      xml_namespaces \
        :ns1 => 'http://example.com',
        :ns2 => 'http://example2.com'

      xml_accessor :ex1
    end

    class RootNode
      include ROXML

      xml_name "RootNode"

      xml_accessor :node, :from => "NamespacedNode", as: NamespacedNode
    end

    before do
       @xml = %{
<RootNode>
  <NamespacedNode xmlns:ns1="http://example.com" xmlns:ns2="http://example2.com">
    <ex1>1</ex1>
  </NamespacedNode>
</RootNode>
       }
    end

    it "should write out namespaces in middle node" do
      expect(RootNode.from_xml(@xml).to_xml.to_s).to eq(@xml.strip)
    end
  end
end
