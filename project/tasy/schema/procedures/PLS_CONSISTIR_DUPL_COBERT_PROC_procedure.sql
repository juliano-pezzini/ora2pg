-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_dupl_cobert_proc ( nr_seq_tipo_cobert_p bigint, nr_seq_cobertura_proc_p bigint, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_grupo_servico_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_duplicada_cober_w	bigint;
ds_erro_w		varchar(400);


BEGIN

ds_erro_w := '';

select	count(*)
into STRICT	qt_duplicada_cober_w
from	pls_cobertura_proc
where	nr_seq_tipo_cobertura		= nr_seq_tipo_cobert_p
and	coalesce(cd_procedimento,0)		= coalesce(cd_procedimento_p,coalesce(cd_procedimento,0))
and	coalesce(ie_origem_proced_p,0)	= coalesce(ie_origem_proced,coalesce(ie_origem_proced_p,0))
and	coalesce(cd_grupo_proc,0)		= coalesce(cd_grupo_proc_p,coalesce(cd_grupo_proc,0))
and	coalesce(cd_especialidade,0)		= coalesce(cd_especialidade_p,coalesce(cd_especialidade,0))
and	coalesce(cd_area_procedimento,0)	= coalesce(cd_area_procedimento_p,coalesce(cd_area_procedimento,0))
and	coalesce(nr_seq_grupo_servico,0)	= coalesce(nr_seq_grupo_servico_p,coalesce(nr_seq_grupo_servico,0))
and	nr_sequencia			<> nr_seq_cobertura_proc_p
and	IE_COBERTURA			= 'S';

if (qt_duplicada_cober_w > 0) then
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280365);
end if;

ds_erro_p := ds_erro_p || ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_dupl_cobert_proc ( nr_seq_tipo_cobert_p bigint, nr_seq_cobertura_proc_p bigint, cd_area_procedimento_p bigint, cd_especialidade_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_grupo_servico_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

