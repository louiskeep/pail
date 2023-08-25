import tkinter as tk

class Calculator:
    def __init__(self, master):
        self.master = master
        master.title("Calculator")
        master.configure(bg='#272727')
        master.resizable(width=False, height=False)

        # Fonts
        display_font = ('Roboto', 32)
        button_font = ('Roboto', 18, 'bold')

        # Colors
        bg_color = '#272727'
        fg_color = '#ffffff'
        button_bg = '#4d4d4d'
        button_active_bg = '#737373'

        # Create display widget
        self.display = tk.Entry(master, width=14, justify='right', font=display_font, bg=bg_color, fg=fg_color, borderwidth=0)
        self.display.grid(row=0, column=0, columnspan=4, pady=10)

        # Buttons
        button_list = [
            '7', '8', '9', '/',
            '4', '5', '6', '*',
            '1', '2', '3', '-',
            '.', '0', 'C', '+',
            '=' 
        ]

        # Add buttons to the frame
        r = 1
        c = 0
        for b in button_list:
            button = tk.Button(master, text=b, width=4, height=2, font=button_font, bg=button_bg, activebackground=button_active_bg, fg=fg_color, borderwidth=0, command=lambda symbol=b: self.on_button_press(symbol))
            button.grid(row=r, column=c, padx=2, pady=2)
            c += 1
            if c > 3:
                c = 0
                r += 1

    def on_button_press(self, symbol):
        if symbol == 'C':
            self.display.delete(0, tk.END)
        elif symbol == '=':
            try:
                result = eval(self.display.get())
            except ZeroDivisionError:
                result = "Math Error"
            except:
                result = "Syntax Error"
            
            self.display.delete(0, tk.END)
            self.display.insert(0, str(result))
        else:
            self.display.insert(tk.END, symbol)


root = tk.Tk()
calculator = Calculator(root)
root.mainloop()
