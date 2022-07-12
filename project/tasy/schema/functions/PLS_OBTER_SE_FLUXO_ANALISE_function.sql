-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_fluxo_analise ( nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


/*
Definição
Esta rotina verifica se a operadora decidi por usar o fluxo normal da análise ou se é utilizado um fluxo alterado

FLUXO DE EXECUÇÃO:
O sistema segue o fluxo de auditoria conforme parametrizado nos grupos de análise.

FLUXO DE EXECUÇÃO / CONTA:
O sistema segue o fluxo de auditoria conforme parametrizado nos grupos de análise, até que seja liberada a última
glosa/ocorrência da CONTA. Após essa última liberação, qualquer grupo poderá realizar a auditoria na conta.


----------------------------------------------------------------------------------------------------------------------------------------------------------
Retorna
S - Se é a vez do usuário
N - Se não é
*/
/*
ie_tipo_fluxo_w
C = Fluxo de execução / Conta
F = Fluxo de execução   		<===== Fluxo Normal - Padrão
*/
ie_retorno_w			varchar(1);
ie_existe_grupos_analise_w	varchar(1);
nr_seq_fluxo_maior_w		bigint;
ie_existe_glosa_oco_pend_w	bigint;
ie_tipo_fluxo_w			varchar(1);
ie_pre_analise_w		varchar(1);


BEGIN

begin
select	coalesce(ie_regra_analise, 'F')
into STRICT	ie_tipo_fluxo_w
from	pls_param_analise_conta
where	cd_estabelecimento = cd_estabelecimento_p;
exception
	when others then
	ie_tipo_fluxo_w := 'F';
end;

select	max(ie_pre_analise)
into STRICT	ie_pre_analise_w
from	pls_analise_Conta
where	nr_sequencia = nr_seq_analise_p;

if (ie_tipo_fluxo_w = 'F') then

	/*Obter o fluxo da vez*/

	select	min(nr_seq_ordem)
	into STRICT	nr_seq_fluxo_maior_w
	from	pls_auditoria_conta_grupo
	where	nr_seq_analise = nr_seq_analise_p
	and	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(ie_pre_analise,'N') = coalesce(ie_pre_analise_w,'N'); /*Diego 16/05/2012 - Estava ocorrendo cassos onde existe grupos de pré-análise não finalizados,
										          durante a análise de pagamento o auditor não tinha acesso pois o sistema não considerava o
										          grupo deste o próximo.*/
	/*Obter se entre o grupo de análise que o auditor faz parte esta com o fluxo inferior*/

	select	CASE WHEN count(nr_seq_ordem)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	pls_auditoria_conta_grupo
	where	nr_seq_grupo	 = nr_seq_grupo_atual_p
	and	nr_seq_analise   = nr_seq_analise_p
	and	nr_seq_ordem     = coalesce(nr_seq_fluxo_maior_w,0);

elsif (ie_tipo_fluxo_w = 'C') then
	/*Obter se existe alguma glosa/ocorrencia de conta ainda sem análise*/

	select  count(*)
	into STRICT	ie_existe_glosa_oco_pend_w
	from    pls_analise_conta_item
	where   nr_seq_analise = nr_seq_analise_p
	and	(nr_seq_conta IS NOT NULL AND nr_seq_conta::text <> '')
	and	coalesce(nr_seq_conta_proc::text, '') = ''
	and	coalesce(nr_seq_conta_mat::text, '') = ''
	and	ie_status = 'P';

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_grupos_analise_w
	from    pls_auditoria_conta_grupo
	where   nr_seq_analise = nr_seq_analise_p;

	/*Se houver glosa / ocorrencia na conta ainda não realizada é seguido flixo do grupo de análise
	    E haver grupos na análise

	    Se não haver grupos (ie_existe_grupos_analise_w = 'N') é permitido o acesso*/
	if (ie_existe_glosa_oco_pend_w > 0) and (ie_existe_grupos_analise_w = 'S') then

		/*Obter entre os gtrupos de análise pendentes qual possui o maior nivel de ordem que não o usuário não faz parte*/

		select	min(nr_seq_ordem)
		into STRICT	nr_seq_fluxo_maior_w
		from	pls_auditoria_conta_grupo
		where	nr_seq_analise = nr_seq_analise_p
		and	coalesce(dt_liberacao::text, '') = '';

		/*Obter se entre os grupos de análise que o auditor faz parte esta algum com o fluxo superior ou igual ao fluxo da vez. O maior ou igual serve para que seja possivel que após um
		auditor ter finalizado sua parte este possa voltar a análise*/
		select	CASE WHEN count(nr_seq_ordem)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_retorno_w
		from	pls_auditoria_conta_grupo
		where	nr_seq_grupo	 = nr_seq_grupo_atual_p
		and	nr_seq_analise   = nr_seq_analise_p
		and	nr_seq_ordem     = coalesce(nr_seq_fluxo_maior_w,0);
	else
		/*Se não houver então é liberado o acesso a análise*/

		ie_retorno_w := 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_fluxo_analise ( nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, nm_usuario_p text) FROM PUBLIC;

