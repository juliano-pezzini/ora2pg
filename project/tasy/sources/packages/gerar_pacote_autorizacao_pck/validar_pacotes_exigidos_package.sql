-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--###################################################################
CREATE OR REPLACE PROCEDURE gerar_pacote_autorizacao_pck.validar_pacotes_exigidos () AS $body$
DECLARE


nr_seq_pacote_w		bigint;
nr_seq_pacote_autor_w	bigint;

c01 CURSOR FOR
SELECT	b.nr_sequencia
from	autor_conv_pacote a,
	convenio_pacote_autor b
where	a.nr_seq_pacote			= b.nr_sequencia
and	a.nr_sequencia_autor		= current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint
and	exists (select	1
	from	convenio_pacote_autor_exig x
	where	x.nr_seq_pacote		= a.nr_seq_pacote
	and	dt_autorizacao_w	between coalesce(x.dt_inicio_vigencia,clock_timestamp() - interval '999 days') and coalesce(x.dt_fim_vigencia,clock_timestamp() + interval '999 days'))
order by a.nr_sequencia;

c02 CURSOR FOR
SELECT	a.nr_sequencia
from 	autor_conv_pacote a
where	a.nr_sequencia_autor	= current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint
and	a.nr_seq_pacote		= nr_seq_pacote_w
and	not exists  --Vejo se não existe pacote gerado  na autorização, onde este pacote possui pacotes exigidos que não foram gerados.
		(select	1
		from	autor_conv_pacote x
		where	x.nr_sequencia_autor	= current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint
		and	x.nr_seq_pacote(select	c.nr_seq_pacote_exigido
						from	convenio_pacote_autor b,
							convenio_pacote_autor_exig c
						where	b.nr_sequencia		= a.nr_seq_pacote
						and	b.nr_sequencia		= c.nr_seq_pacote
						and	dt_autorizacao_w	between coalesce(c.dt_inicio_vigencia,clock_timestamp() - interval '999 days') and coalesce(c.dt_fim_vigencia,clock_timestamp() + interval '999 days')));


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_pacote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_pacote_autor_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		delete 	from autor_conv_pacote a
		where	a.nr_sequencia_autor	= current_setting('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w')::bigint
		and	a.nr_sequencia		= nr_seq_pacote_autor_w;

		CALL gerar_pacote_autorizacao_pck.set_pacote_excluido(nr_seq_pacote_w);

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pacote_autorizacao_pck.validar_pacotes_exigidos () FROM PUBLIC;
