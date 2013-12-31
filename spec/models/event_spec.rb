require 'spec_helper'

describe Event do
  before do
    @event = Event.new(name:            "Example Event", 
                       event_start:     "2099-08-20 18:30:00".to_datetime,
                       event_end:       "2099-08-20 18:30:00".to_datetime,
                       event_type:            10, 
                       ref_id:          1)
  end
  
  subject { @event }
  
  it { should respond_to(:name) }
  it { should respond_to(:event_start) }
  it { should respond_to(:event_end) }
  it { should respond_to(:event_type) }
  it { should respond_to(:ref_id) }
    
end
