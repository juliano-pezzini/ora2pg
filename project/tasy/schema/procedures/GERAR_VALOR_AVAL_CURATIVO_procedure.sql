-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_valor_aval_curativo ( nr_seq_aval_cur_p bigint ) AS $body$
DECLARE

  qt_valor_w bigint;
  sql_w varchar(250);
  qt_valor_out_w bigint;
  ds_split_w varchar(32767) := '';
  c01 CURSOR FOR
    SELECT coalesce(qt_valor, 0) as qt_valor
    from 	cur_curativo_item
    where nr_seq_curativo = nr_seq_aval_cur_p;

  c01_w c01%rowtype;


BEGIN
  if (nr_seq_aval_cur_p IS NOT NULL AND nr_seq_aval_cur_p::text <> '') then
    open c01;
    loop
      fetch c01 into c01_w;
      EXIT WHEN NOT FOUND; /* apply on c01 */
      begin
        ds_split_w := to_char(c01_w.qt_valor) || ',' || ds_split_w;
      end;
    end loop;
    close c01;

    ds_split_w := replace(
           replace(
               replace(ds_split_w, CHR(10), '')
           , CHR(13), '')
       , CHR(09), '');

    begin
      sql_w := 'CALL GERAR_VALOR_AVAL_CURATIVO_MD(:1) INTO :qt_valor_out_w';
      EXECUTE sql_w
        USING IN ds_split_w,
              OUT qt_valor_out_w;
    exception
      when others then
        qt_valor_out_w := null;
      end;

    update cur_curativo_esp
    set 	 qt_escore = coalesce(qt_valor_out_w, 0)
    where	 nr_sequencia = nr_seq_aval_cur_p;
  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_valor_aval_curativo ( nr_seq_aval_cur_p bigint ) FROM PUBLIC;
