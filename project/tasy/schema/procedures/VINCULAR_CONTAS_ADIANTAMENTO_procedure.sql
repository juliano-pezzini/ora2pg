-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_contas_adiantamento (nr_adiantamento_p bigint, ds_lista_contas_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_interno_conta_w	bigint;
nr_sequencia_w		bigint;
vl_contas_w		double precision;
vl_adiantamento_w	double precision;
cont_w			integer;
vl_saldo_w		adiantamento.vl_saldo%type;

c01 CURSOR FOR 
SELECT	nr_interno_conta 
from	conta_paciente 
where	' ' || ds_lista_contas_p || ' ' like '% ' || nr_interno_conta || ' %' 
and	(ds_lista_contas_p IS NOT NULL AND ds_lista_contas_p::text <> '');


BEGIN 
ds_erro_p	:= null;
 
if (coalesce(ds_lista_contas_p::text, '') = '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265609,'');
	--Nenhuma conta foi selecionada! 
end if;
 
if (ds_lista_contas_p IS NOT NULL AND ds_lista_contas_p::text <> '') then 
 
	open c01;
	loop 
	fetch c01 into 
		nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	coalesce(max(nr_sequencia),0) + 1 
		into STRICT	nr_sequencia_w 
		from	conta_paciente_adiant 
		where	nr_interno_conta	= nr_interno_conta_w 
		and	nr_adiantamento		= nr_adiantamento_p;
		 
		/*OS 1496628, cfme analise da OS*/
	 
		select	max(vl_saldo) 
		into STRICT	vl_saldo_w 
		from	adiantamento 
		where	nr_adiantamento = nr_adiantamento_p;
 
		insert	into conta_paciente_adiant(nr_interno_conta, 
						  nr_adiantamento, 
						  vl_adiantamento, 
						  dt_atualizacao, 
						  nm_usuario, 
						  nr_sequencia, 
						  ie_tipo_adiant) 
					values (nr_interno_conta_w, 
						  nr_adiantamento_p, 
						  coalesce(vl_saldo_w,0), /*OS 1496628, cfme analise da OS*/
 
						  clock_timestamp(), 
						  nm_usuario_p, 
						  nr_sequencia_w, 
						  null);
 
	end loop;
	close c01;
 
	select	count(*) 
	into STRICT	cont_w 
	from	conta_paciente_adiant 
	where	coalesce(obter_titulo_conta(nr_interno_conta)::text, '') = '' 
	and	nr_adiantamento	= nr_adiantamento_p;
 
	if (cont_w = 0) then 
 
		select	coalesce(sum(b.vl_conta),0) 
		into STRICT	vl_contas_w 
		from	conta_paciente b, 
			conta_paciente_adiant a 
		where	a.nr_interno_conta	= b.nr_interno_conta 
		and	a.nr_adiantamento	= nr_adiantamento_p;
 
		select	coalesce(vl_adiantamento,0) 
		into STRICT	vl_adiantamento_w 
		from	adiantamento 
		where	nr_adiantamento	= nr_adiantamento_p;
 
		if (vl_contas_w > vl_adiantamento_w) then 
			ds_erro_p	:= wheb_mensagem_pck.get_texto(280102);
		end if;
 
	end if;
end if;
 
if (coalesce(ds_erro_p::text, '') = '') then 
	commit;
else 
	rollback;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_contas_adiantamento (nr_adiantamento_p bigint, ds_lista_contas_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

