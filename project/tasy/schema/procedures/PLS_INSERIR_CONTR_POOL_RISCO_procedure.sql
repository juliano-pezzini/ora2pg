-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_contr_pool_risco ( nr_seq_grupo_p pls_grupo_contrato.nr_sequencia%type, qt_vidas_inicio_p bigint, qt_vidas_fim_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ie_relacionamento_emp_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

					
ie_data_aniversario_contrato_w	varchar(1);
dt_aniversario_contrato_w	pls_contrato.dt_contrato%type;
qt_vidas_contrato_dt_aniver_w	bigint;
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
nr_seq_grupo_contrato_w		pls_grupo_contrato.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_contrato,
		trunc(a.dt_contrato,'dd') dt_contrato,
		a.nr_contrato
	from	pls_contrato a
	where	(a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')
	and	(a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')
	and	trunc(a.dt_contrato,'dd') <= dt_fim_w
	and	((ie_relacionamento_emp_p = 'S') or
		((ie_relacionamento_emp_p = 'N') and (not exists (SELECT 1
								from	pls_contrato_grupo x,
									pls_grupo_contrato y
								where	y.nr_sequencia = x.nr_seq_grupo
								and	a.nr_sequencia = x.nr_seq_contrato
								and	y.ie_tipo_relacionamento = '1'))))
	and	not exists (	select	1
				from	pls_contrato_grupo x
				where	x.nr_seq_grupo = nr_seq_grupo_p
				and	a.nr_sequencia = x.nr_seq_contrato)
	
union

	select	a.nr_sequencia nr_seq_contrato,
		trunc(a.dt_contrato,'dd') dt_contrato,
		a.nr_contrato
	from	pls_contrato a
	where	(a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')
	and	coalesce(a.cd_cgc_estipulante::text, '') = ''
	and	a.ie_empresario_individual = 'S'
	and	trunc(a.dt_contrato,'dd') <= dt_fim_w
	and	((ie_relacionamento_emp_p = 'S') or 
		((ie_relacionamento_emp_p = 'N') and (not exists (select 1
								from	pls_contrato_grupo x,
									pls_grupo_contrato y
								where	y.nr_sequencia = x.nr_seq_grupo
								and	a.nr_sequencia = x.nr_seq_contrato
								and	y.ie_tipo_relacionamento = '1'))))
	and	not exists (	select	1
				from	pls_contrato_grupo x
				where	x.nr_seq_grupo = nr_seq_grupo_p
				and	a.nr_sequencia = x.nr_seq_contrato);
					
BEGIN

if	(trunc(dt_fim_p,'dd') <> trunc((add_months(dt_inicio_p, 12) -1), 'dd')) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1122258);
end if;

dt_inicio_w	:= trunc(dt_inicio_p,'dd');
dt_fim_w	:= fim_dia(dt_fim_p);

for r_c01_w in c01 loop
	begin
	
	dt_aniversario_contrato_w	:= r_c01_w.dt_contrato;
	ie_data_aniversario_contrato_w	:= 'N';
	
	while(ie_data_aniversario_contrato_w = 'N') loop
		begin
		if (dt_aniversario_contrato_w between dt_inicio_w and dt_fim_w) then
			ie_data_aniversario_contrato_w	:= 'S';
		else
			dt_aniversario_contrato_w	:= add_months(dt_aniversario_contrato_w,12);
		end if;
		end;
	end loop;
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_grupo_contrato_w
	from	pls_grupo_contrato	a,
		pls_contrato_grupo	b
	where	a.nr_sequencia	= b.nr_seq_grupo
        and	a.ie_tipo_relacionamento = '1'
	and	b.nr_seq_contrato = r_c01_w.nr_seq_contrato;
	
	if (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then	
		qt_vidas_contrato_dt_aniver_w	:= pls_qt_vidas_grupo_contrato(nr_seq_grupo_contrato_w,'QV',dt_aniversario_contrato_w);
		
	else	
		select	count(1)
		into STRICT	qt_vidas_contrato_dt_aniver_w
		from	pls_segurado
		where	nr_seq_contrato = r_c01_w.nr_seq_contrato
		and	dt_contratacao <= dt_aniversario_contrato_w
		and	coalesce(dt_cancelamento::text, '') = ''
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao IS NOT NULL AND dt_rescisao::text <> '' AND dt_rescisao >= dt_aniversario_contrato_w));
	end if;
	
	if (qt_vidas_contrato_dt_aniver_w between coalesce(qt_vidas_inicio_p, 0) and coalesce(qt_vidas_fim_p, 9999999999)) then
		insert into pls_contrato_grupo(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec, nr_seq_contrato,
			nr_seq_grupo, ie_reajuste_grupo, cd_estabelecimento,
			nr_contrato)
		values (nextval('pls_contrato_grupo_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, r_c01_w.nr_seq_contrato,
			nr_seq_grupo_p, 'S', cd_estabelecimento_p,
			r_c01_w.nr_contrato);
	end if;
	end;
end loop;

update	pls_grupo_contrato
set	dt_inicio_vigencia 	= coalesce(dt_inicio_w, dt_inicio_vigencia),
	dt_fim_vigencia 	= coalesce(dt_fim_w, dt_fim_vigencia),
	nm_usuario 		= nm_usuario_p,
	dt_atualizacao 		= clock_timestamp()
where	nr_sequencia 		= nr_seq_grupo_p;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_contr_pool_risco ( nr_seq_grupo_p pls_grupo_contrato.nr_sequencia%type, qt_vidas_inicio_p bigint, qt_vidas_fim_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ie_relacionamento_emp_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
