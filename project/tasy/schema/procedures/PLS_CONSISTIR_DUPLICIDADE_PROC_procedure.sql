-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_duplicidade_proc ( nr_seq_cpt_p bigint, nr_tipo_proc_cpt_p bigint, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_cid_p text, ie_tipo_guia_p text, nr_seq_tipo_acomodacao_p bigint, nr_seq_grupo_servico_p bigint, ie_origem_p text, CD_CATEGORIA_CID_p text, ds_erro_p INOUT text) AS $body$
DECLARE


/*ie_origem_p
S - CPT
C - Carência
*/
qt_duplicada_cpt_w	bigint;
ds_erro_w		varchar(400);


BEGIN

ds_erro_w := '';

select	count(*)
into STRICT	qt_duplicada_cpt_w
from	pls_carencia_proc
where	nr_seq_tipo_carencia		= nr_seq_cpt_p
and	coalesce(cd_area_procedimento,0)	= coalesce(cd_area_procedimento_p,coalesce(cd_area_procedimento,0))
and	coalesce(cd_especialidade,0)		= coalesce(cd_especialidade_p,coalesce(cd_especialidade,0))
and	coalesce(cd_grupo_proc,0)		= coalesce(cd_grupo_proc_p,coalesce(cd_grupo_proc,0))
and	coalesce(cd_procedimento,0)		= coalesce(cd_procedimento_p,coalesce(cd_procedimento,0))
and	coalesce(ie_origem_proced,0)		= coalesce(ie_origem_proced_p,coalesce(ie_origem_proced,0))
and	coalesce(cd_doenca_cid,'0')		= coalesce(cd_doenca_cid_p,coalesce(cd_doenca_cid,'0'))
and	coalesce(ie_tipo_guia,'0')		= coalesce(ie_tipo_guia_p,coalesce(ie_tipo_guia,'0'))
and	coalesce(nr_seq_tipo_acomodacao,0)	= coalesce(nr_seq_tipo_acomodacao_p,coalesce(nr_seq_tipo_acomodacao,0))
and	coalesce(nr_seq_grupo_servico,0)	= coalesce(nr_seq_grupo_servico_p,coalesce(nr_seq_grupo_servico,0))
and	coalesce(trim(both CD_CATEGORIA_CID),'0')	= coalesce(CD_CATEGORIA_CID_p,coalesce(trim(both CD_CATEGORIA_CID),'0'))
and	nr_sequencia			<> nr_tipo_proc_cpt_p
and	ie_liberado			= 'S';

if (qt_duplicada_cpt_w > 0) then
	if (ie_origem_p = 'S') then
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280199);
	elsif (ie_origem_p = 'C') then
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280201);
	end if;
end if;

ds_erro_p := ds_erro_p || ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_duplicidade_proc ( nr_seq_cpt_p bigint, nr_tipo_proc_cpt_p bigint, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_doenca_cid_p text, ie_tipo_guia_p text, nr_seq_tipo_acomodacao_p bigint, nr_seq_grupo_servico_p bigint, ie_origem_p text, CD_CATEGORIA_CID_p text, ds_erro_p INOUT text) FROM PUBLIC;

