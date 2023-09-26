parameter DOLLAR = 1;
parameter EURO = 0.93871;
parameter WON = 1335.9;
parameter YEN = 148.29;

module tb;
  
  class change;
    task chmachine(input string f_name, input string s_name, input real amount);
      real ch;
      if (f_name == "DOLLAR") begin
        ch = amount * EURO;
      end else begin
        ch = amount / EURO;
      end

      this.display(f_name, s_name, amount, ch);
    endtask
    
    task display(input string f_name, input string s_name, input real amount, ch);
      $display("%f %s = %f %s", amount, f_name, ch, s_name);
    endtask
  endclass

  class won extends change;
    task chmachine(input string f_name, input string s_name, input real amount);
      real ch;
      if (f_name == "DOLLAR") begin
        ch = amount * WON;
      end else begin
        ch = amount / WON;
      end

      super.display(f_name, s_name, amount, ch);
    endtask
  endclass

  class yen extends change;
    task chmachine(input string f_name, input string s_name, input real amount);
      real ch;
      if (f_name == "DOLLAR") begin
        ch = amount * YEN;
      end else begin
        ch = amount / YEN;
      end

      super.display(f_name, s_name, amount, ch);
    endtask
  endclass

  initial begin
    change c = new();
    won w = new();
    yen y = new();
    c.chmachine("DOLLAR", "EURO", 10);
    c.chmachine("EURO", "DOLLAR", 10);
    w.chmachine("DOLLAR", "WON", 100);
    y.chmachine("DOLLAR", "YEN", 100);
  end
endmodule
