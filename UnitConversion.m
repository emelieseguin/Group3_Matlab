classdef UnitConversion
   methods(Static)
        function meters = Inches2Meters(inches)
        meters = inches/39.37;
        end
        function inches = Meters2Inches(meters)
            inches = meters*39.37;
        end
        function Newton = Lbf2Newton(Lbf)
            Newton = Lbf*4.448222;
        end
        function Lbf = Newton2Lbf(Newton)
            Lbf = Newton/4.448222;
        end
        function Pa = Psi2Pa(Psi)
            Pa = Psi*6894.757;
        end
        function Psi = Pa2Psi(Pa)
            Psi = Pa/6894.757;
        end
        function NewtonM = PoundFInch2NewtonM(PoundF)
            NewtonM = PoundF/8.850746;
        end
        function PoundFInch = NewtonM2PoundFInch(NewtonM)
            PoundFInch = NewtonM*8.850746;
        end
        function NewtonperMeter = PoundFperInch2NewtonperMeter(PoundFperInch)
            NewtonperMeter = PoundFperInch*175.127;
        end
    end
end


