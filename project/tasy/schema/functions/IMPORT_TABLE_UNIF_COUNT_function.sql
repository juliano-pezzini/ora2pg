-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION import_table_unif_count (cd_consulta_p text, cd_grupo_p text, cd_subgrupo_p text, cd_doenca_cid_p text, cd_procedimento_p text, cd_forma_organizacao_p text, cd_habilitacao_p text, cd_detalhe_p text, cd_servico_p text, cd_tipo_leito_p text, cd_servico_classif_p text, cd_registro_p text, cd_modalidade_p text, cd_grupo_habilitacao_p text, cd_reg_proc_princ_p text, cd_reg_proc_sec_p text, nr_seq_detalhe_p text, ds_competencia_p text, nr_seq_status_imp_p text, nm_arquivo_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w sus_grupo.nr_sequencia%type;


BEGIN

if (cd_consulta_p = '246457')then
        select 	count(*)
	into STRICT    qt_retorno_w
	from 	sus_grupo 
	where 	cd_grupo = cd_grupo_p;
end if;

if (cd_consulta_p = '246575')then
	select 	count(*)
	into STRICT    qt_retorno_w
	from 	sus_subgrupo
	where	cd_subgrupo = cd_subgrupo_p;
end if;

if (cd_consulta_p = '246577')then
	select 	nr_sequencia 
	into STRICT    qt_retorno_w
	from 	sus_grupo 
	where 	cd_grupo = cd_grupo_p;
end if;

if (cd_consulta_p = '246904')then
	select  count(*)
	into STRICT    qt_retorno_w
	from 	cid_doenca
	where 	cd_doenca_cid = cd_doenca_cid_p;
end if;

if (cd_consulta_p = '246773')then
	select  count(*)
	into STRICT    qt_retorno_w
	from    sus_procedimento
	where   cd_procedimento = cd_procedimento_p;
end if;

if (cd_consulta_p = '246606')then
	select	nr_sequencia
	into STRICT    qt_retorno_w
	from	sus_subgrupo
	where 	cd_subgrupo = cd_subgrupo_p;
end if;

if (cd_consulta_p = '246602')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_forma_organizacao
	where 	cd_forma_organizacao = cd_forma_organizacao_p;
end if;

if (cd_consulta_p = '246635')then
	select	sus_obter_grupo_proc(cd_procedimento_p,7)
	into STRICT    qt_retorno_w
	;
end if;

if (cd_consulta_p = '246643')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	procedimento 	
	where	cd_procedimento = cd_procedimento_p
	and 	ie_origem_proced = 7;
end if;

if (cd_consulta_p = '246686')then
	select	nr_sequencia
	into STRICT	qt_retorno_w
	from	sus_forma_organizacao
	where 	cd_forma_organizacao = cd_forma_organizacao_p;
end if;

if (cd_consulta_p = '246710')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_habilitacao
	where	cd_habilitacao = cd_habilitacao_p;
end if;

if (cd_consulta_p = '246715')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_detalhe
	where	cd_detalhe = cd_detalhe_p;
end if;

if (cd_consulta_p = '246718')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_servico
	where	cd_servico = cd_servico_p;
end if;

if (cd_consulta_p = '246722')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_tipo_leito_unif
	where 	cd_tipo_leito = cd_tipo_leito_p;
end if;

if (cd_consulta_p = '246724')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_servico_classif
	where 	cd_servico_classif = (cd_servico_classif_p)::numeric
	and 	cd_servico = (cd_servico_p)::numeric;
end if;

if (cd_consulta_p = '246735')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_registro
	where 	cd_registro = cd_registro_p;
end if;

if (cd_consulta_p = '246736')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_modalidade
	where 	cd_modalidade = cd_modalidade_p;
end if;

if (cd_consulta_p = '246741')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_espec_leito
	where	cd_espec_leito = cd_tipo_leito_p;
end if;

if (cd_consulta_p = '246744')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_grupo_habilitacao
	where 	cd_grupo_habilitacao = cd_grupo_habilitacao_p;
end if;

if (cd_consulta_p = '246746')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	procedimento
	where 	ie_origem_proced = 7
	and 	cd_procedimento = cd_procedimento_p;
end if;

if (cd_consulta_p = '246763')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_registro
	where 	cd_registro = cd_reg_proc_princ_p;
end if;

if (cd_consulta_p = '246766')then
	select	count(*)
	into STRICT 	qt_retorno_w
	from 	sus_registro
	where 	cd_registro = cd_reg_proc_sec_p;
end if;

if (cd_consulta_p = '246780')then
	select 	nr_sequencia
	into STRICT	qt_retorno_w
	from 	sus_detalhe
	where	cd_detalhe = cd_detalhe_p;
end if;

if (cd_consulta_p = '246782')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_detalhe_proc
	where	cd_procedimento   	= cd_procedimento_p
        and	nr_seq_detalhe    	= nr_seq_detalhe_p
        and	trunc(to_date(ds_competencia_p,'yyyymm'),'month') = trunc(dt_compt_ini,'month');
end if;

if (cd_consulta_p = '246807')then
	select	count(*)
	into STRICT	qt_retorno_w
	from 	sus_modalidade
	where	cd_modalidade	 = cd_modalidade_p;
end if;

if (cd_consulta_p = '246846')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_registro
	where 	cd_registro = cd_registro_p;
end if;

if (cd_consulta_p = '246848')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_servico_classif
	where 	cd_servico_classif = cd_servico_classif_p;
end if;

if (cd_consulta_p = '246859')then
	select	nr_sequencia
	into STRICT	qt_retorno_w
	from	sus_grupo_habilitacao
	where	cd_grupo_habilitacao = cd_grupo_habilitacao_p;
end if;

if (cd_consulta_p = '246865')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_espec_leito
	where	cd_espec_leito = cd_tipo_leito_p;
end if;

if (cd_consulta_p = '246862')then
	select	nr_sequencia
	into STRICT	qt_retorno_w	
	from 	sus_espec_leito
	where	cd_espec_leito  = cd_tipo_leito_p
	and	cd_tipo_leito   = cd_tipo_leito_p;
end if;

if (cd_consulta_p = '246871')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_habilitacao
	where	cd_habilitacao = cd_habilitacao_p;
end if;

if (cd_consulta_p = '246912')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_procedimento_generico
	where 	cd_procedimento = cd_procedimento_p;
end if;

if (cd_consulta_p = '246854')then
	select	b.nr_sequencia
	into STRICT	qt_retorno_w
	from 	sus_servico a,
                sus_servico_classif b
	where	b.cd_servico_classif = cd_servico_classif_p 
	and	a.cd_servico	= cd_servico_p 
	and 	a.nr_sequencia	= b.nr_seq_servico;
end if;

if (cd_consulta_p = '247066')then
	select	coalesce(max(nr_sequencia), 0) + 1
	into STRICT	qt_retorno_w
	from	sus_proced_incremento_origem;
end if;

if (cd_consulta_p = '246857')then
	select 	count(*)
	into STRICT	qt_retorno_w
	from 	sus_habilitacao
	where 	cd_habilitacao = cd_habilitacao_p;
end if;

if (cd_consulta_p = '246727')then
	select	nr_sequencia
	into STRICT	qt_retorno_w
	from 	sus_servico
	where 	cd_servico = cd_servico_p;
end if;

if (cd_consulta_p = '246648')then
	select	count(*)
	into STRICT	qt_retorno_w
	from	sus_procedimento 	
	where	cd_procedimento = cd_procedimento_p
	and 	ie_origem_proced = 7;
end if;

if (cd_consulta_p = '246650')then
        select  count(1)
        into STRICT    qt_retorno_w
        from    sus_status_arq_txt a
        where   a.nr_seq_status_imp = nr_seq_status_imp_p
        and     a.ie_status_import in ('F', 'E');
end if;

if (cd_consulta_p = '246651')then
        select  count(1)
        into STRICT    qt_retorno_w
        from    sus_status_arq_txt a
        where   a.nr_seq_status_imp = nr_seq_status_imp_p
        and     a.nm_arquivo = nm_arquivo_p
        and     a.ie_status_import = 'E';
end if;

if (cd_consulta_p = '246652')then
        select  count(1)
        into STRICT    qt_retorno_w
        from    sus_status_arq_txt a
        where   a.nr_seq_status_imp = nr_seq_status_imp_p;
end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION import_table_unif_count (cd_consulta_p text, cd_grupo_p text, cd_subgrupo_p text, cd_doenca_cid_p text, cd_procedimento_p text, cd_forma_organizacao_p text, cd_habilitacao_p text, cd_detalhe_p text, cd_servico_p text, cd_tipo_leito_p text, cd_servico_classif_p text, cd_registro_p text, cd_modalidade_p text, cd_grupo_habilitacao_p text, cd_reg_proc_princ_p text, cd_reg_proc_sec_p text, nr_seq_detalhe_p text, ds_competencia_p text, nr_seq_status_imp_p text, nm_arquivo_p text) FROM PUBLIC;

