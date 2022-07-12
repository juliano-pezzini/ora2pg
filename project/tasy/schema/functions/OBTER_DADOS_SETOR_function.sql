-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_setor ( cd_setor_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nm_unidade_basica_w	varchar(20);
nm_unidade_compl_w	varchar(20);
ds_retorno_w		varchar(255);
ds_ocup_hosp_w		setor_atendimento.ds_ocup_hosp%type;

/*
UB - Descrição da Unidade Básica
UC - Descrição da Unidade Complementar
DO - Descrição da ocupação hospitalar
PR - Descrição da prescrição
TL - Telefone
CL - Classificação
NC - Nome Curto
CR - Código da pessoa responsável
NR - Nome da pessoa responsável
UR - Usuário da pessoa responsável
AD - Andar do setor
BL - Bloco do andar
E  - Estabeleciomento
EB - Estabelecimento base
LO - Código do local de estoque
DL - Descricao do local de estoque
DS - descrição setor
EP - Email do setor
AC - Código do agrupamento
DA - Descrição do agrupamento
CO - Complexidade assist
DC - Descrição curta/Setor
MP - Move o prontuário
MPF- Mostra paciente
SE - Setor externo
ARP - Agrupa REP dia na cópia
CCD - Centro Custo Despesa
*/
BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	begin
	if (ie_opcao_p = 'EB') then
		select  coalesce(max(cd_estabelecimento_base),1)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'MPF') then
		select  coalesce(max(ie_mostra_paciente),'S')
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'MP') then
		select	coalesce(max(ie_move_prontuario),'N')
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'UB') then
		select	nm_unidade_basica
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'UC') then
		select	nm_unidade_compl
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'PR') then
		select	ds_prescricao
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'DO') then
		select	ds_ocup_hosp
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'TL') then
		select	nr_telefone
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'CL') then
		select	cd_classif_setor
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'NC') then
		select	NM_CURTO
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'CR') then
		select	cd_pessoa_resp
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'NR') then
		select	substr(obter_nome_pf(cd_pessoa_resp),1,255)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'UR') then
		select	substr(obter_usuario_pessoa(cd_pessoa_resp),1,15)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'AD')	then
		select	substr(obter_desc_andar(nr_seq_andar),1,255)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'BL')	then
		select	substr(obter_desc_bloco(b.nr_seq_bloco),1,255)
		into STRICT	ds_retorno_w
		from	setor_atendimento a,
				andar_setor b
		where	a.nr_seq_andar = b.nr_sequencia
		and		cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'E')	then
		select	cd_estabelecimento
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'LO')	then
		select	cd_local_estoque
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'DL')	then
		select	substr(obter_desc_local_Estoque(cd_local_estoque),1,255)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'DS')	then
		select	ds_setor_atendimento
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'EP')	then
		select	ds_email_padrao
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'CO')	then
		select	ie_complexidade_assit
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'DA')	then
		select	ds_agrupamento
		into STRICT	ds_retorno_w
		from	agrupamento_setor b,
			setor_atendimento a
		where	b.nr_sequencia		= a.nr_seq_agrupamento
		and	a.cd_setor_atendimento	= cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'AC')	then
		select	max(b.nr_sequencia)
		into STRICT	ds_retorno_w
		from	agrupamento_setor b,
			setor_atendimento a
		where	b.nr_sequencia		= a.nr_seq_agrupamento
		and	a.cd_setor_atendimento	= cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'DC') then
		select	substr(coalesce(ds_descricao,ds_setor_atendimento),1,100)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'SE')	then
		select	max(cd_setor_externo)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'ARP') then
		select	coalesce(max(ie_agrupar_rep_dia), 'N')
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	elsif (ie_opcao_p = 'CCD') then
		select	max(cd_centro_custo)
		into STRICT	ds_retorno_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_setor ( cd_setor_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

