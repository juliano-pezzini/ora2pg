-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_preco_servico () AS $body$
DECLARE


qt_dec_w		smallint;
qt_reg_w		integer;
vl_retorno_w		double precision;

BEGIN


select data_scale
into STRICT qt_dec_w
from user_tab_columns
where table_name = 'PRECO_SERVICO'
  and column_name = 'VL_SERVICO';
if (qt_dec_w = 2) then
	begin
	/*insert into logxxx_tasy values(sysdate, 'Tasy', 999, 'Decimais iniciais: ' || qt_dec_w);*/

	select count(*) into STRICT qt_reg_w from preco_servico;
	/*insert into logxxxx_tasy values(sysdate, 'Tasy', 999, 'Registros iniciais: ' || qt_reg_w);*/

	vl_retorno_w := Obter_Valor_Dinamico('Create table marcus_preco_servico as select * from preco_servico', vl_retorno_w);
	vl_retorno_w := Obter_Valor_Dinamico('select count(*) from Marcus_preco_servico', vl_retorno_w);
	/*insert into logxxx_tasy values(sysdate, 'Tasy', 999, 'Registros copia: ' || vl_retorno_w);*/

	if (coalesce(vl_retorno_w,0) > 0) then
		begin
		vl_retorno_w := Obter_Valor_Dinamico('truncate table preco_servico', vl_retorno_w);
		vl_retorno_w := Obter_Valor_Dinamico('alter table preco_servico modify vl_servico number(15,4)', vl_retorno_w);
		vl_retorno_w := Obter_Valor_Dinamico('insert into preco_servico select * from marcus_preco_servico', vl_retorno_w);
		commit;
		vl_retorno_w := Obter_Valor_Dinamico('select count(*) from preco_servico', vl_retorno_w);
		/*insert into logxxx_tasy values(sysdate, 'Tasy', 999, 'Registros Finais: ' || vl_retorno_w);*/

		if (vl_retorno_w <> qt_reg_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(256034);
		end if;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_preco_servico () FROM PUBLIC;

