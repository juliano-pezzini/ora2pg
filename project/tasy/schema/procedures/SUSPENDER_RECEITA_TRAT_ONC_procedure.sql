-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_receita_trat_onc ( nr_seq_paciente_p bigint, nr_ciclo_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ds_retorno_w		varchar(4000) := '';
ds_receitas_w		varchar(4000) := '';
nr_sequencia_w		bigint;
nr_receita_w		varchar(15);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_receita
	from	fa_receita_farmacia
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_ciclo = nr_ciclo_p
	and	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(dt_cancelamento::text, '') = ''
	order by nr_receita;


BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') and (nr_ciclo_p IS NOT NULL AND nr_ciclo_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w,
		nr_receita_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		begin
		CALL fa_cancelar_receita(nr_sequencia_w,nm_usuario_p);
		exception when others then
			if (coalesce(ds_receitas_w::text, '') = '') then
				ds_receitas_w := nr_receita_w || chr(29);
			else
				ds_receitas_w := ds_receitas_w ||' , '||nr_receita_w || chr(29);
			end if;
		end;
		end;
	end loop;
	close C01;

	If (ds_receitas_w IS NOT NULL AND ds_receitas_w::text <> '') then

		ds_retorno_w := Wheb_mensagem_pck.get_texto(307857, 'DS_RECEITAS_W='||ds_receitas_w); --'As seguinte receitas não foram canceladas: '|| chr(10)||ds_receitas_w;
	end if;
end if;

ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_receita_trat_onc ( nr_seq_paciente_p bigint, nr_ciclo_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

