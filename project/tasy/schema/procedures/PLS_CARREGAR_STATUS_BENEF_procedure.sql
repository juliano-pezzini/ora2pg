-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_carregar_status_benef ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_segurado_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_plano_w		pls_util_cta_pck.t_number_table;
tb_dt_inicial_w			pls_util_cta_pck.t_date_table;
tb_dt_final_w			pls_util_cta_pck.t_date_table;
tb_dt_final_ref_w		pls_util_cta_pck.t_date_table;
tb_nr_seq_motivo_cancel_w	pls_util_cta_pck.t_number_table;
dt_referencia_w			timestamp;

indice_w	bigint;
ie_primeiro_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado,
		a.nr_seq_plano,
		a.dt_contratacao,
		a.dt_rescisao,
		a.nr_seq_motivo_cancelamento,
		(	SELECT	count(1)
			from	pls_segurado_alt_plano x
			where	x.nr_seq_segurado = a.nr_sequencia
			and	x.ie_situacao = 'A') qt_alt_plano
	from	pls_segurado a
	where	(a.nr_seq_contrato IS NOT NULL AND a.nr_seq_contrato::text <> '')
	and	(a.dt_contratacao IS NOT NULL AND a.dt_contratacao::text <> '')
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')  --Somente beneficiarios liberados
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	not exists (	select	1
				from	pls_segurado_status x
				where	x.nr_seq_segurado = a.nr_sequencia);

C02 CURSOR(	nr_seq_segurado_pc	pls_segurado.nr_sequencia%type) FOR
	SELECT	a.dt_alteracao,
		a.nr_seq_plano_ant,
		a.nr_seq_plano_atual,
		(	SELECT	min(x.dt_alteracao)
			from	pls_segurado_alt_plano x
			where	x.nr_seq_segurado = a.nr_seq_segurado
			and	x.nr_sequencia <> a.nr_sequencia
			and	x.ie_situacao = 'A'
			and	x.dt_alteracao > a.dt_alteracao) dt_proxima_alt_plano
	from	pls_segurado_alt_plano a
	where	a.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.ie_situacao = 'A'
	order by a.dt_alteracao;

C03 CURSOR(	dt_referencia_pc	timestamp) FOR
	SELECT	a.nr_sequencia
	from	pls_segurado_status a
	where	a.dt_inicial >= dt_referencia_pc
	and	coalesce(a.ie_envio_sib::text, '') = '';
	
C04 CURSOR(	dt_referencia_pc	timestamp) FOR
	SELECT	a.nr_sequencia
	from	pls_segurado_status a
	where	a.dt_final >= dt_referencia_pc
	and	coalesce(a.ie_exclusao_sib::text, '') = '';
	
procedure limpar_vetores is;
BEGIN
indice_w := 0;
tb_nr_seq_segurado_w.delete;
tb_nr_seq_plano_w.delete;
tb_dt_inicial_w.delete;
tb_dt_final_w.delete;
tb_dt_final_ref_w.delete;
tb_nr_seq_motivo_cancel_w.delete;
end;

procedure inserir_segurado_status is
begin
if (tb_nr_seq_segurado_w.count > 0) then
	forall i in tb_nr_seq_segurado_w.first..tb_nr_seq_segurado_w.last
		insert	into pls_segurado_status(
				nr_sequencia, nr_seq_segurado, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_plano, dt_inicial, dt_final,
				dt_final_ref, nr_seq_motivo_cancelamento,
				ie_envio_sib, ie_exclusao_sib
				)
		values ( 	nextval('pls_segurado_status_seq'), tb_nr_seq_segurado_w(i), clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				tb_nr_seq_plano_w(i), tb_dt_inicial_w(i), tb_dt_final_w(i),
				tb_dt_final_ref_w(i), tb_nr_seq_motivo_cancel_w(i),
				null, null
				);
	commit;
	CALL CALL limpar_vetores();
end if;
end;

begin
CALL CALL limpar_vetores();

--Deletar os registros existentes
delete	from pls_segurado_status a
where	exists (	SELECT	1
		from	pls_segurado x
		where	x.nr_sequencia = a.nr_seq_segurado
		and	x.cd_estabelecimento = cd_estabelecimento_p)
and not exists (	select	1
		from	pls_sib_movimento x
		where	x.nr_seq_status_inclusao = a.nr_sequencia)
and not exists (	select	1
		from	pls_sib_movimento x
		where	x.nr_seq_status_exclusao = a.nr_sequencia);
commit;

CALL Tasy_posicionar_sequence('PLS_SEGURADO_STATUS','NR_SEQUENCIA','R');

for	r_C01_w in C01 loop
	begin
	tb_nr_seq_segurado_w(indice_w)		:= r_c01_w.nr_seq_segurado;
	tb_nr_seq_plano_w(indice_w)		:= r_c01_w.nr_seq_plano;
	tb_dt_inicial_w(indice_w)		:= r_c01_w.dt_contratacao;
	tb_dt_final_w(indice_w)			:= r_c01_w.dt_rescisao;
	tb_dt_final_ref_w(indice_w)		:= pls_util_pck.obter_dt_vigencia_null(r_c01_w.dt_rescisao,'F');
	tb_nr_seq_motivo_cancel_w(indice_w)	:= r_c01_w.nr_seq_motivo_cancelamento;
	
	if (r_c01_w.qt_alt_plano > 0) then
		ie_primeiro_w	:= 'S';
		for r_c02_w in C02(r_c01_w.nr_seq_segurado) loop
			begin
			indice_w	:= indice_w + 1;
			if (ie_primeiro_w = 'S') then
				tb_nr_seq_plano_w(indice_w-1)		:= r_c02_w.nr_seq_plano_ant;
				tb_dt_final_w(indice_w-1)		:= fim_dia(r_c02_w.dt_alteracao-1);
				tb_dt_final_ref_w(indice_w-1)		:= fim_dia(pls_util_pck.obter_dt_vigencia_null(r_c02_w.dt_alteracao-1,'F'));
				tb_nr_seq_motivo_cancel_w(indice_w-1)	:= null;
				ie_primeiro_w	:= 'N';
			end if;
			
			tb_nr_seq_segurado_w(indice_w)		:= r_c01_w.nr_seq_segurado;
			tb_nr_seq_plano_w(indice_w)		:= r_c02_w.nr_seq_plano_atual;
			tb_dt_inicial_w(indice_w)		:= r_c02_w.dt_alteracao;
			if (r_c02_w.dt_proxima_alt_plano IS NOT NULL AND r_c02_w.dt_proxima_alt_plano::text <> '') then
				tb_dt_final_w(indice_w)			:= fim_dia(r_c02_w.dt_proxima_alt_plano-1);
				tb_dt_final_ref_w(indice_w)		:= fim_dia(pls_util_pck.obter_dt_vigencia_null(r_c02_w.dt_proxima_alt_plano-1,'F'));
				tb_nr_seq_motivo_cancel_w(indice_w)	:= null;
			else
				tb_dt_final_w(indice_w)			:= r_c01_w.dt_rescisao;
				tb_dt_final_ref_w(indice_w)		:= pls_util_pck.obter_dt_vigencia_null(r_c01_w.dt_rescisao,'F');
				tb_nr_seq_motivo_cancel_w(indice_w)	:= r_c01_w.nr_seq_motivo_cancelamento;
			end if;
			
			end;
		end loop;
	end if;
	
	if (indice_w >= pls_util_pck.qt_registro_transacao_w) then
		inserir_segurado_status;
	else
		indice_w	:= indice_w +1;
	end if;
	
	end;
end loop;

inserir_segurado_status;

dt_referencia_w	:= trunc(clock_timestamp(), 'mm');

for r_c03_w in c03(dt_referencia_w) loop
	begin
	
	update	pls_segurado_status
	set	ie_envio_sib = 1
	where	nr_sequencia = r_c03_w.nr_sequencia;
	
	end;
end loop;

for r_c04_w in c04(dt_referencia_w) loop
	begin
	
	update	pls_segurado_status
	set	ie_exclusao_sib = 4
	where	nr_sequencia = r_c04_w.nr_sequencia;
	
	end;
end loop;

CALL pls_ajustar_migracao_benef_sib(cd_estabelecimento_p, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_carregar_status_benef ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
