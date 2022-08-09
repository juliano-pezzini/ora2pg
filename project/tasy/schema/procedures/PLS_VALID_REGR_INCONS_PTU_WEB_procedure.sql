-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valid_regr_incons_ptu_web (nr_seq_requisicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_status_item_w		varchar(2);
ie_status_item_regra_w		integer;
ie_tipo_guia_w			varchar(2);
nr_seq_proc_w			bigint;
nr_seq_mat_w			bigint;
nr_seq_inconsistencia_w		bigint;
ds_mensagem_w			varchar(255);
ds_mensagem_ret_w		varchar(255) := null;
qt_reg_ptu_incon_w		bigint;

C01 CURSOR FOR
	SELECT	a.ie_tipo_guia,
		b.ie_status,
		b.nr_sequencia nr_seq_proc,
		null nr_seq_mat
	from	pls_requisicao a,
		pls_requisicao_proc b
	where	a.nr_sequencia = b.nr_seq_requisicao
	and	a.nr_sequencia = nr_seq_requisicao_p
	
union

	SELECT	a.ie_tipo_guia,
		b.ie_status,
		null nr_seq_proc,
		b.nr_sequencia nr_seq_mat
	from	pls_requisicao a,
		pls_requisicao_mat b
	where	a.nr_sequencia = b.nr_seq_requisicao
	and	a.nr_sequencia = nr_seq_requisicao_p;


BEGIN

open C01;
loop
fetch C01 into
	ie_tipo_guia_w,
	ie_status_item_w,
	nr_seq_proc_w,
	nr_seq_mat_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		if (ie_status_item_w  ('S','P')) then
			ie_status_item_regra_w := 2;
		elsif (ie_status_item_w in ('N','G')) then
			ie_status_item_regra_w := 3;
		elsif (ie_status_item_w in ('A')) then
			ie_status_item_regra_w := 1;
		end if;

		begin
			select	a.nr_seq_inconsistencia,
				a.ds_mensagem_intercambio
			into STRICT	nr_seq_inconsistencia_w,
				ds_mensagem_w
			from	pls_ret_audit_estip_int a
			where	((coalesce(a.ie_guia_consulta,'N') = 'S' and ie_tipo_guia_w = '3')
			or (coalesce(a.ie_guia_spsadt,'N') = 'S' and ie_tipo_guia_w = '2')
			or (coalesce(a.ie_guia_internacao,'N') = 'S' and ie_tipo_guia_w = '1'))
			and	coalesce(a.ie_status_item_analise, ie_status_item_regra_w)  = ie_status_item_regra_w
			and	ie_situacao = 'A'  LIMIT 1;
		exception
		when others then
			nr_seq_inconsistencia_w := null;
		end;

		select	count(1)
		into STRICT	qt_reg_ptu_incon_w
		from	ptu_intercambio_consist
		where	nr_seq_procedimento = coalesce(nr_seq_proc_w,0)
		or	nr_seq_material = coalesce(nr_seq_mat_w,0);

		if ((nr_seq_inconsistencia_w IS NOT NULL AND nr_seq_inconsistencia_w::text <> '') and qt_reg_ptu_incon_w = 0) then

			insert into	ptu_intercambio_consist(nr_sequencia, cd_estabelecimento, dt_atualizacao,
								nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
								nr_seq_requisicao, cd_transacao, nr_seq_material,
								nr_seq_procedimento, ds_observacao, nr_seq_inconsistencia)
							values (nextval('ptu_intercambio_consist_seq'), cd_estabelecimento_p, clock_timestamp(),
								nm_usuario_p, clock_timestamp(), nm_usuario_p,
								nr_seq_requisicao_p, '00404', nr_seq_mat_w,
								nr_seq_proc_w, ds_mensagem_w, nr_seq_inconsistencia_w);
		end if;

		--prioriza a menasgem do item negado
		if (coalesce(ds_mensagem_ret_w::text, '') = '' or ie_status_item_regra_w = 3) then
			ds_mensagem_ret_w := ds_mensagem_w;
		end if;

	end;
end loop;
close C01;

if (ds_mensagem_ret_w IS NOT NULL AND ds_mensagem_ret_w::text <> '') then
	update	ptu_resposta_auditoria
	set	ds_observacao = ds_mensagem_ret_w
	where	nr_seq_requisicao = nr_seq_requisicao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valid_regr_incons_ptu_web (nr_seq_requisicao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
