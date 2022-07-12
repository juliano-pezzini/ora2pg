-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_resultado_retif ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_consiste_modif_p text default 'N', ie_consiste_regra_p text default 'N') RETURNS varchar AS $body$
DECLARE


nm_usuario_w               varchar(15);
dt_atualizacao_w           timestamp;
ie_retificacao_w           varchar(1);

ds_resultado_anter_w       varchar(4000);
qt_resultado_anter_w       double precision;
pr_resultado_anter_w       double precision;
ds_resultado_anter_final_w varchar(4000);

ds_resultado_atual_w       varchar(4000);
qt_resultado_atual_w       double precision;
pr_resultado_atual_w       double precision;
ds_resultado_atual_final_w varchar(4000);

nr_seq_resultado_w         bigint;
qt_casas_decimais_w        bigint;
ie_formato_resultado_w     varchar(3);
nr_seq_material_w          bigint;
nm_exame_w                 varchar(255);

nm_pessoa_fisica_w         pessoa_fisica.nm_pessoa_fisica%type;
nr_conselho_w              varchar(255);

ie_liberado_w              varchar(1);


BEGIN
ds_resultado_anter_final_w   := '';

select  nr_seq_resultado
into STRICT    nr_seq_resultado_w
from    exame_lab_resultado
where   nr_prescricao = nr_prescricao_p;

if (coalesce(ie_consiste_modif_p, 'N') = 'S') then

    select CASE WHEN coalesce(max(a.dt_aprovacao)::text, '') = '' THEN  'N'  ELSE 'S' END
    into STRICT   ie_liberado_w
    from   exame_lab_result_item a
    where  a.nr_seq_resultado = nr_seq_resultado_w and
           a.nr_seq_prescr = nr_seq_prescr_p and
           (a.nr_seq_material IS NOT NULL AND a.nr_seq_material::text <> '');

else

    ie_liberado_w := 'N';

end if;

if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then

    begin
        select  a.nm_usuario,
                a.dt_atualizacao,
                a.ds_resultado ds_resultado_anter,
                a.qt_resultado qt_resultado_anter,
                a.pr_resultado pr_resultado_anter,
                b.ds_resultado ds_resultado_atual,
                b.qt_resultado qt_resultado_atual,
                b.pr_resultado pr_resultado_atual,
                CASE WHEN a.qt_decimais=0 THEN  -1  ELSE a.qt_decimais END  qt_decimais,
                a.nr_seq_material,
                obter_desc_exame(nr_seq_exame_p) nm_exame
        into STRICT    nm_usuario_w,
                dt_atualizacao_w,
                ds_resultado_anter_w,
                qt_resultado_anter_w,
                pr_resultado_anter_w,
                ds_resultado_atual_w,
                qt_resultado_atual_w,
                pr_resultado_atual_w,
                qt_casas_decimais_w,
                nr_seq_material_w,
                nm_exame_w
        from    w_exame_lab_result_item a,
                exame_lab_result_item b
        where   a.nr_seq_resultado = nr_seq_resultado_w
        and     a.nr_seq_prescr = nr_seq_prescr_p
        and     a.nr_seq_exame = nr_seq_exame_p
        and     b.nr_seq_resultado = nr_seq_resultado_w
        and     b.nr_seq_prescr = nr_seq_prescr_p
        and     b.nr_seq_exame = nr_seq_exame_p
        and (CASE WHEN a.ds_resultado=b.ds_resultado THEN  'N'  ELSE 'S' END  = 'S'
        or      CASE WHEN a.qt_resultado=b.qt_resultado THEN  'N'  ELSE 'S' END  = 'S'
        or      CASE WHEN a.pr_resultado=b.pr_resultado THEN  'N'  ELSE 'S' END  = 'S'
        or      coalesce(ie_liberado_w, 'N') = 'N');

        select  CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END  ie_retificacao
        into STRICT    ie_retificacao_w
        from    lab_motivo_desaprov a,
                PRESCR_PROC_DESAPROV b
        where   b.nr_prescricao = nr_prescricao_p and
                b.nr_seq_prescr = nr_seq_prescr_p and
                a.nr_sequencia = b.nr_seq_motivo_desaprov and
                a.ie_retificacao = 'S'  LIMIT 1;

    EXCEPTION
        when no_data_found then
            return '';
        end;

    if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
        select max(ie_formato_resultado)
        into STRICT ie_formato_resultado_w
        from exame_lab_material
        where   nr_seq_exame = nr_seq_exame_p
        and nr_seq_material = nr_seq_material_w
        order by ie_prioridade;
    end if;

    if ((coalesce(nr_seq_material_w::text, '') = '') or (coalesce(ie_formato_resultado_w::text, '') = '')) then
        select ie_formato_resultado
        into STRICT ie_formato_resultado_w
        from exame_laboratorio
        where nr_seq_exame = nr_seq_exame_p;
    end if;

    if (ie_formato_resultado_w = 'DV') then
        ds_resultado_anter_final_w := coalesce(ds_resultado_anter_w, to_char(qt_resultado_anter_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9')));
        ds_resultado_atual_final_w := coalesce(ds_resultado_atual_w, to_char(qt_resultado_atual_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9')));
    elsif ((ie_formato_resultado_w = 'V') or (ie_formato_resultado_w = 'CV')) then
        ds_resultado_anter_final_w := to_char(qt_resultado_anter_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9'));
        ds_resultado_atual_final_w := to_char(qt_resultado_atual_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9'));
    elsif (ie_formato_resultado_w = 'VP') then
        ds_resultado_anter_final_w := coalesce(to_char(qt_resultado_anter_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9')), to_char(pr_resultado_anter_w, RPAD('999G999G990D', 12 + qt_casas_decimais_w, '9')));
        ds_resultado_atual_final_w := coalesce(to_char(qt_resultado_atual_w, RPAD('999G999G999G999G990D', 20 + qt_casas_decimais_w, '9')), to_char(pr_resultado_atual_w, RPAD('999G999G990D', 12 + qt_casas_decimais_w, '9')));
    elsif (ie_formato_resultado_w = 'P') then
        ds_resultado_anter_final_w := to_char(pr_resultado_anter_w, RPAD('999G999G990D', 12 + qt_casas_decimais_w, '9'));
        ds_resultado_atual_final_w := to_char(pr_resultado_atual_w, RPAD('999G999G990D', 12 + qt_casas_decimais_w, '9'));
    else
        ds_resultado_anter_final_w := ds_resultado_anter_w;
        ds_resultado_atual_final_w := ds_resultado_atual_w;
    end if;


    select  coalesce(max(coalesce(obter_nome_pf(u.cd_pessoa_fisica), u.ds_usuario)), nm_usuario_w),
            coalesce(max(coalesce(pf.ds_codigo_prof, m.nr_crm)), 0)
    into STRICT    nm_pessoa_fisica_w,
            nr_conselho_w
    FROM usuario u
LEFT OUTER JOIN pessoa_fisica pf ON (u.cd_pessoa_fisica = pf.cd_pessoa_fisica)
LEFT OUTER JOIN medico m ON (u.cd_pessoa_fisica = m.cd_pessoa_fisica)
WHERE u.nm_usuario = nm_usuario_w;



    if (ds_resultado_anter_final_w IS NOT NULL AND ds_resultado_anter_final_w::text <> '') then
        if (ie_retificacao_w = 'S') then
            return WHEB_MENSAGEM_PCK.get_texto(917751,
                'NM_EXAME='           ||nm_exame_w||
                ';RESULTADO_ANTERIOR='||trim(both ds_resultado_anter_final_w)||
                ';RESULTADO_ATUAL='   ||trim(both ds_resultado_atual_final_w)||
                ';DT_DESAPROV='       ||to_char(dt_atualizacao_w, 'dd/MM/yyyy hh24:mi')||
                ';NM_USUARIO='        ||WHEB_MENSAGEM_PCK.get_texto(995608,
                    'nm_pessoa_fisica='||nm_pessoa_fisica_w||
                    ';nr_conselho='||nr_conselho_w));
        else
			if (ie_consiste_regra_p = 'N') then
				return WHEB_MENSAGEM_PCK.get_texto(378967,
					'NM_USUARIO='  ||nm_usuario_w||
					';DT_DESAPROV='||to_char(dt_atualizacao_w, 'dd/MM/yyyy hh24:mi')||
					';RESULT_ANT=' ||trim(both ds_resultado_anter_final_w));
			end if;
        end if;
    else
        return '';
    end if;
else
    return '';
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_resultado_retif ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_consiste_modif_p text default 'N', ie_consiste_regra_p text default 'N') FROM PUBLIC;

