-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_json_printer.dbms_output_clob (my_clob text, delim text, jsonp text default null) AS $body$
DECLARE

    prev bigint := 1;
    indx bigint := 1;
    size_of_nl bigint := lengthb(delim);
    v_str varchar(32767);
    amount bigint := 8191;

BEGIN
    if (jsonp IS NOT NULL AND jsonp::text <> '') then RAISE NOTICE '%(', jsonp; end if;
    while(indx != 0) loop

      indx := dbms_lob.instr(my_clob, delim, prev+1);


      if (indx = 0) then

        amount := 8191;

        loop
          dbms_lob.read(my_clob, amount, prev, v_str);
          RAISE NOTICE '%', v_str;
          prev := prev+amount-1;
          exit when prev >= octet_length(my_clob);
        end loop;
      else
        amount := indx - prev;
        if (amount > 8191) then
          amount := 8191;

          loop
            dbms_lob.read(my_clob, amount, prev, v_str);
            RAISE NOTICE '%', v_str;
            prev := prev+amount-1;
            amount := indx - prev;
            exit when prev >= indx - 1;
            if (amount > 8191) then amount := 8191; end if;
          end loop;
          prev := indx + size_of_nl;
        else
          dbms_lob.read(my_clob, amount, prev, v_str);
          RAISE NOTICE '%', v_str;
          prev := indx + size_of_nl;
        end if;
      end if;

    end loop;
    if (jsonp IS NOT NULL AND jsonp::text <> '') then RAISE NOTICE ')'; end if;

  end;



$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_json_printer.dbms_output_clob (my_clob text, delim text, jsonp text default null) FROM PUBLIC;
