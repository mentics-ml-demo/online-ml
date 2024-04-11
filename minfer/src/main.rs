use chrono::NaiveDateTime;
use rust_tradier::data::{Handler, start};

struct Test {
    data:String
}

impl Handler<String> for Test {
    fn on_data(&mut self, timestamp:NaiveDateTime, data:String) {
        println!("Handler::on_data received: {:?}", data);
        self.data = data;
    }
}

fn main() {
    println!("Begin");
    let h = Test { data: "none yet".to_string() };
    start(h);
    std::thread::sleep(std::time::Duration::from_secs(4));
    println!("End");
}
