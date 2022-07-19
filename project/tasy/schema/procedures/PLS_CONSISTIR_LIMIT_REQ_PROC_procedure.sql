-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_limit_req_proc ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_solicitada_p bigint, nr_seq_requisicao_p bigint, nr_seq_req_proc_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_limita_w			varchar(1)	:= 'N';
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
ie_liberado_w			varchar(1)	:= 'N';
qt_permitida_w			double precision;
ie_periodo_w			varchar(2);
qt_meses_intervalo_w		integer;
nr_seq_limitacao_proc_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_tipo_limitacao_w		bigint;
qt_registros_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_intercambio_w		bigint;

c01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.ie_limitacao, 
		a.nr_seq_tipo_limitacao, 
		c.qt_permitida, 
		c.qt_meses_intervalo, 
		c.nr_seq_contrato, 
		c.nr_seq_plano 
	from	pls_limitacao c, 
		pls_tipo_limitacao b, 
		pls_limitacao_proc a 
	where	a.nr_seq_tipo_limitacao	= b.nr_sequencia 
	and	c.nr_seq_tipo_limitacao	= b.nr_sequencia 
	and	clock_timestamp() between coalesce(c.dt_inicio_vigencia,clock_timestamp()) and coalesce(c.dt_fim_vigencia,clock_timestamp()) 
	and	c.nr_sequencia		in	(	SELECT	x.nr_sequencia 
							from	pls_limitacao x 
							where	x.nr_seq_contrato		= nr_seq_contrato_p 
							and	((x.NR_SEQ_PLANO_CONTRATO	= nr_seq_plano_p) or (coalesce(x.NR_SEQ_PLANO_CONTRATO::text, '') = '')) 
							and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp()) 
							
union
 
							select	x.nr_sequencia 
							from	pls_limitacao x 
							where	x.nr_seq_intercambio	= nr_seq_intercambio_w 
							and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp()) 
							
union
 
							select	x.nr_sequencia 
							from	pls_limitacao x 
							where	x.nr_seq_plano			= nr_seq_plano_p 
							and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp()) 
							and	not exists (	select	1 
										from	pls_limitacao x 
										where	x.nr_seq_contrato	= nr_seq_contrato_p 
										and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp())) 
							and	not exists (	select	1 
										from	pls_limitacao z 
										where	x.nr_seq_intercambio	= nr_seq_intercambio_w 
										and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp()))) 
	and	coalesce(a.cd_procedimento,cd_procedimento_p)	= cd_procedimento_p 
	and	coalesce(a.ie_origem_proced,ie_origem_proced_w) 	= ie_origem_proced_w 
	and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w 
	and	coalesce(a.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w 
	and	coalesce(a.cd_area_procedimento, cd_area_w) 		= cd_area_w 
	and	(((a.nr_seq_grupo_servico IS NOT NULL AND a.nr_seq_grupo_servico::text <> '') and pls_se_grupo_preco_servico_lib(a.nr_seq_grupo_servico,cd_procedimento_p,ie_origem_proced_p) = 'S') or (coalesce(a.nr_seq_grupo_servico::text, '') = '')) 
	and	coalesce(a.cd_doenca_cid::text, '') = '' 
	and	coalesce(a.ie_tipo_guia::text, '') = '' 
	and	b.ie_situacao	= 'A' 
	order by 
		a.cd_area_procedimento, 
		a.cd_especialidade, 
		a.cd_grupo_proc, 
		a.cd_procedimento, 
		CASE WHEN a.ie_limitacao='S' THEN  0  ELSE 1 END;

BEGIN
 
SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w;
	 
select	max(nr_seq_intercambio) 
into STRICT	nr_seq_intercambio_w 
from	pls_segurado 
where	nr_sequencia	= nr_seq_segurado_p;
	 
open c01;
loop 
fetch c01 into	 
	nr_seq_limitacao_proc_w, 
	ie_liberado_w, 
	nr_seq_tipo_limitacao_w, 
	qt_permitida_w, 
	qt_meses_intervalo_w, 
	nr_seq_contrato_w, 
	nr_seq_plano_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;
 
if (ie_liberado_w = 'S') then 
	select	substr(pls_obter_se_limit_req(	nr_seq_segurado_p, nr_seq_tipo_limitacao_w, qt_permitida_w, 
						 qt_solicitada_p, nr_seq_requisicao_p, 'P'),1,1) 
	into STRICT	ie_limita_w 
	;
 
/*	if	(ie_limita_w = 'S') then 
		ptu_inserir_inconsistencia(nr_seq_requisicao_p,2014,'',cd_estabelecimento_p,nm_usuario_p); 
	end if; 
*/
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_limit_req_proc ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_solicitada_p bigint, nr_seq_requisicao_p bigint, nr_seq_req_proc_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

