require 'rails_helper'


RSpec.describe ModelLabel, type: :model do
  before :context do
    class ModelLabelConfig::Course
      include Mongoid::Document
      include Mongoid::Timestamps
    end

    class ModelLabelConfigQuestion
      include Mongoid::Document
      include Mongoid::Timestamps
    end

    ModelLabel.set_config {
      "课程"   => ModelLabelConfig::Course,
      "测试题" => ModelLabelConfigQuestion
    }
  end

  describe "field validates" do
    describe "model_name 取值必须在 config 中配置的模型名范围内" do
      it{
        ModelLabel.get_models.each do |model|
          ml = ModelLabel::Label.new(:model_name => model.to_s)
          expect(ml.valid?).to eq(true)
        end
      }

      it{
        ml = ModelLabel::Label.new(:model_name => "Lifeihahah")
        expect(ml.valid?).to eq(false)
      }
    end

    describe "model_name name 两个字段取值联合唯一" do
      it{
        name = "方向"
        model_name = "ModelLabelConfig::Course"
        expect{
          ml = ModelLabel::Label.create(:model_name => model_name, :name => name, :values => ["a","b"])
          expect(ml.valid?).to eq(true)
        }.to change{
          ModelLabel.count
        }.by(1)

        name2 = "职务"
        expect{
          ml = ModelLabel::Label.create(:model_name => model_name, :name => name2, :values => ["a","b"])
          expect(ml.valid?).to eq(true)
        }.to change{
          ModelLabel.count
        }.by(1)

        name = "方向"
        expect{
          ml = ModelLabel::Label.create(:model_name => model_name, :name => name, :values => ["a","b"])
          expect(ml.valid?).to eq(false)
          expect(m.errors.message[:model_name]).not_to be_nil
        }.to change{
          ModelLabel.count
        }.by(0)
      }
    end

    describe "values 取值的数组中，不能有重复的数组元素" do
      it{
        model_name = "ModelLabelConfig::Course"
        expect{
          ml = ModelLabel.create(:model_name => model_name, :name => "方向", :values => ["a","a"])
          expect(ml.valid?).to eq(false)
          expect(m.errors.message[:values]).not_to be_nil
        }.to change{
          ModelLabel.count
        }.by(0)

        expect{
          ml = ModelLabel.create(:model_name => model_name, :name => "方向", :values => ["a", :a])
          expect(ml.valid?).to eq(false)
          expect(m.errors.message[:values]).not_to be_nil
        }.to change{
          ModelLabel.count
        }.by(0)

        expect{
          ml = ModelLabel.create(:model_name => model_name, :name => "方向", :values => ["1", 1])
          expect(ml.valid?).to eq(false)
          expect(m.errors.message[:values]).not_to be_nil
        }.to change{
          ModelLabel.count
        }.by(0)
      }
    end
  end

  describe "ModelLabelConfig::Course 设置 label" do
    before{
      name1 = "方向"
      ModelLabel.create(:model_name => "ModelLabelConfig::Course", :name => name1, :values => ["法律","经济"])

      name2 = "类型"
      ModelLabel.create(:model_name => "ModelLabelConfig::Course", :name => name2, :values => ["视频","PPT"])
    }

    describe "create" do
      it{
        expect{
          course = ModelLabelConfig::Course.create(
            :label_info => {"方向" => ["经济"]}
          )
          expect(ModelLabelConfig::Course.where(:"label_info.方向".in => ["经济"]).to_a).to inlcude(course)
        }.to change{
          ModelLabelConfig::Course.count
        }.by(1)

      }
    end

    describe "course.set_label(name, values)" do
      # TODO
    end

    describe "course.add_label(name, value)" do
      # TODO
    end

    describe "course.remove_label(name, value)" do
      # TODO
    end
  end

  describe "ModelLabelConfig::Course.with_label(name, value)" do
    # TODO
  end

  describe "ModelLabelConfig::Course.get_label_names" do
    # TODO
  end

  describe "course.get_label_values(label_name)" do
    # TODO
  end
end