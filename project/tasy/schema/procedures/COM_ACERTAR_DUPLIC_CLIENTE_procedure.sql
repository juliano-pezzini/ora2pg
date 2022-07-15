-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_acertar_duplic_cliente (nr_seq_cliente_orig_p bigint, nr_seq_cliente_dest_p bigint, nm_usuario_p text) AS $body$
DECLARE



VarSql				varchar(1) := chr(39);
qt_erro_w			integer;
nm_tabela_w			varchar(50);
nm_atributo_w			varchar(50);

nm_tabela_pj_w		varchar(50);
nm_atributo_pj_w		varchar(50);

nr_sequencia_w		bigint;
trigger_name_w		varchar(30);
nm_tabela_ww			varchar(50) := null;
cd_cgc_orig_w		varchar(14);
cd_cgc_dest_w		varchar(14);

/* obter integridades e atributos a serem atualizados */

c01 CURSOR FOR
SELECT	a.nm_tabela,
	b.nm_atributo
from 	integridade_atributo b,
     	integridade_referencial a
where 	a.nm_tabela			= b.nm_tabela
and 	a.nm_integridade_referencial	= b.nm_integridade_referencial
and 	a.nm_tabela_referencia 		= 'COM_CLIENTE'
order 	by 1;

c05 CURSOR FOR
SELECT	a.nm_tabela,
	b.nm_atributo
from 	integridade_atributo b,
     	integridade_referencial a
where 	a.nm_tabela			= b.nm_tabela
and 	a.nm_integridade_referencial	= b.nm_integridade_referencial
and 	a.nm_tabela 			= 'PESSOA_JURIDICA_COMPL'
and	a.nm_tabela_referencia		= 'PESSOA_JURIDICA'

union

select	a.nm_tabela,
	b.nm_atributo
from 	integridade_atributo b,
     	integridade_referencial a
where 	a.nm_tabela			= b.nm_tabela
and 	a.nm_integridade_referencial	= b.nm_integridade_referencial
and 	a.nm_tabela 			= 'CONTRATO'
and	a.nm_tabela_referencia		= 'PESSOA_JURIDICA'
order 	by 1;

c02 CURSOR FOR
SELECT	trigger_name
from	user_triggers
where	table_name = nm_tabela_w
order	by 1;

c03 CURSOR FOR
SELECT	trigger_name
from	user_triggers
where	table_name = nm_tabela_ww
order	by 1;


BEGIN

if (coalesce(nr_seq_cliente_orig_p,0) = 0) or (coalesce(nr_seq_cliente_dest_p,0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(256023);
end if;

if (nr_seq_cliente_orig_p = nr_seq_cliente_dest_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(256024);
end if;

/* gerar integridades e atributos a serem atualizados */

open c01;
loop
fetch c01 into
	nm_tabela_w,
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/* tratar triggers */

	if (coalesce(nm_tabela_ww::text, '') = '') or (nm_tabela_ww <> nm_tabela_w) then

		if (coalesce(nm_tabela_ww::text, '') = '') then
			nm_tabela_ww := nm_tabela_w;
		else
			/* habilitar triggers tabela anterior */

			open c03;
			loop
			fetch c03 into
				trigger_name_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				exec_sql_dinamico('ACDUPLICCLI','alter trigger ' || trigger_name_w || ' enable');
				end;
			end loop;
			close c03;
			nm_tabela_ww := nm_tabela_w;
		end if;

		open c02;
		loop
		fetch c02 into
			trigger_name_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			exec_sql_dinamico('ACDUPLICCLI','alter trigger ' || trigger_name_w || ' disable');
			end;
		end loop;
		close c02;

	end if;

	open c05;
	loop
	fetch c05 into
		nm_tabela_pj_w,
		nm_atributo_pj_w;
	EXIT WHEN NOT FOUND; /* apply on c05 */
		begin

		select	cd_cnpj
		into STRICT	cd_cgc_orig_w
		from	com_cliente
		where	nr_sequencia = nr_seq_cliente_orig_p;

		select	cd_cnpj
		into STRICT	cd_cgc_dest_w
		from	com_cliente
		where	nr_sequencia = nr_seq_cliente_dest_p;

		CALL altera_valor_campo_tabela(nm_tabela_pj_w, nm_atributo_pj_w, cd_cgc_orig_w, cd_cgc_dest_w);
		end;
	end loop;
	close c05;

	CALL altera_valor_campo_tabela(nm_tabela_w, nm_atributo_w, nr_seq_cliente_orig_p, nr_seq_cliente_dest_p);

	exception
	when others then
		open c02;
		loop
		fetch c02 into trigger_name_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			exec_sql_dinamico('ACDUPLICCLI','alter trigger ' || trigger_name_w || ' enabled');
			end;
		end loop;
		close c02;
	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
	trigger_name_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	CALL exec_sql_dinamico('ACDUPLICCLI','alter trigger ' || trigger_name_w || ' enabled');
end loop;
close c02;

/*insert into log_xxxtasy	(dt_atualizacao,
			nm_usuario,
			cd_log,
			ds_log)
values			(sysdate,
			nm_usuario_p,
			5900,
			'Acerto de duplicidade do cliente ' || to_char(nr_seq_cliente_orig_p) || ' para ' || to_char(nr_seq_cliente_dest_p)); */
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_acertar_duplic_cliente (nr_seq_cliente_orig_p bigint, nr_seq_cliente_dest_p bigint, nm_usuario_p text) FROM PUBLIC;

