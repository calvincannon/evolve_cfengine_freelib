require 'spec_helper'

describe "280 efl test" do
   
   testdir = '/tmp/efl_test/280'

   describe file ( "#{testdir}" ) do
      it { should be_directory}
      it { should be_mode 700 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
   end
   describe file ( "#{testdir}/a" ) do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
   end
   describe file ( "#{testdir}/b" ) do
      it { should be_file }
      it { should be_mode 600 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
   end
   describe file ( "#{testdir}/d" ) do
      it { should be_file }
      it { should be_mode 755 }
      it { should be_owned_by 'sys' }
      it { should be_grouped_into 'sys' }
   end

   describe file ( "#{testdir}/sub" ) do
      it { should be_directory}
      it { should be_mode 700 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
   end

end

