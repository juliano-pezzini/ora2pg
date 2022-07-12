-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_tc_result (nr_seq_pendencia_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE

  ie_resultado_w     varchar(1);
  ds_result_w        varchar(4000);
  qt_registro_w      bigint;
  nr_current_cycle_w reg_integrated_test_result.nr_seq_ciclo%type;


BEGIN

  select max(nr_seq_ciclo)
    into STRICT nr_current_cycle_w
    from reg_integrated_test_result
   where nr_seq_pendencia = nr_seq_pendencia_p;

  if (nr_seq_pendencia_p IS NOT NULL AND nr_seq_pendencia_p::text <> '') then

    select substr(ie_status, 1, 1)
      into STRICT ie_resultado_w
      from reg_integrated_test_pend
     where nr_sequencia = nr_seq_pendencia_p;

    if (ie_resultado_w <> 'E') then
    
      select coalesce(count(*), 0)
        into STRICT qt_registro_w
        from reg_integrated_test_result
       where nr_seq_pendencia = nr_seq_pendencia_p
         and nr_seq_ciclo = nr_current_cycle_w;

      if (qt_registro_w = 0) then
        begin
          ie_resultado_w := 'P';
        end;
      else
        begin

          select coalesce(count(*), 0)
            into STRICT qt_registro_w
            from reg_integrated_test_result
           where nr_seq_pendencia = nr_seq_pendencia_p
             and coalesce(ie_resultado, 'P') = 'B'
             and nr_seq_ciclo = nr_current_cycle_w;

          if (qt_registro_w > 0) then
            begin
              ie_resultado_w := 'B';
            end;
          else
            begin

              select coalesce(count(*), 0)
                into STRICT qt_registro_w
                from reg_integrated_test_result
               where nr_seq_pendencia = nr_seq_pendencia_p
                 and coalesce(ie_resultado, 'P') = 'F'
                 and nr_seq_ciclo = nr_current_cycle_w;

              if (qt_registro_w > 0) then
                begin
                  ie_resultado_w := 'F';
                end;
              else
                begin

                  select coalesce(count(*), 0)
                    into STRICT qt_registro_w
                    from reg_integrated_test_result
                   where nr_seq_pendencia = nr_seq_pendencia_p
                     and coalesce(ie_resultado::text, '') = ''
                     and nr_seq_ciclo = nr_current_cycle_w;

                  if (qt_registro_w = 0) then
                    begin
                      ie_resultado_w := 'C';
                    end;
                  else
                    ie_resultado_w := 'P';
                  end if;
                end;
              end if;
            end;
          end if;
        end;
      end if;
    end if;
  end if;

  if (ie_tipo_retorno_p = 'C') then
    begin
      ds_result_w := ie_resultado_w;
    end;
  else
    begin

      if (ie_resultado_w = 'B') then
        ds_result_w := obter_texto_tasy(834402, null);
      elsif (ie_resultado_w = 'F') then
        ds_result_w := obter_texto_tasy(834401, null);
      elsif (ie_resultado_w = 'C') then
        ds_result_w := obter_texto_tasy(834404, null);
      elsif (ie_resultado_w = 'E') then
        ds_result_w := obter_texto_tasy(1030005, null);
      else
        ds_result_w := obter_texto_tasy(834400, null);
      end if;
    end;
  end if;

  return ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_tc_result (nr_seq_pendencia_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;
