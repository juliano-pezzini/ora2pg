-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ins_hist_request_build_so (nr_sequence_so_p bigint, cd_version_p text, ie_platform_p text, nm_usuario_p text, branch_name_p text) AS $body$
DECLARE


DS_TEXT varchar(1000);

cd_funcao_w funcao.cd_funcao%type;
nm_usuario_lider_w grupo_desenvolvimento.nm_usuario_lider%type;
ds_locale_user_w user_locale.ds_locale%type;
cd_exp_funcao_w funcao.cd_exp_funcao%type;
branch_name_w man_custom_branch.branch_name%type;
nr_seq_ordem_serv_w man_ordem_servico.nr_sequencia%type;
nm_platform_w varchar(4000);


BEGIN

  if ((nr_sequence_so_p IS NOT NULL AND nr_sequence_so_p::text <> '')
    and (cd_version_p IS NOT NULL AND cd_version_p::text <> '') 
    and (ie_platform_p IS NOT NULL AND ie_platform_p::text <> '')
    and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')) then
    
    select distinct coalesce(g.nm_usuario_lider,'jpweiss'), obtain_user_locale(coalesce(g.nm_usuario_lider,'jpweiss'))
      into STRICT nm_usuario_lider_w, ds_locale_user_w
      from  man_ordem_servico mos
      left join funcao f on (mos.cd_funcao = f.cd_funcao)
      left join funcao_grupo_des gf on (f.cd_funcao = gf.cd_funcao)
      left JOIN grupo_desenvolvimento g ON (gf.nr_seq_grupo = g.nr_sequencia)
     where mos.nr_sequencia = nr_sequence_so_p  LIMIT 1;

    select distinct CASE WHEN ie_platform_p='H' THEN 'HTML5'                                         WHEN ie_platform_p='D' THEN 'Delphi'                                         WHEN ie_platform_p='S' THEN 'Script'                                         WHEN ie_platform_p='J' THEN 'Java Swing'                                         WHEN ie_platform_p='G' THEN 'GWT'                                         WHEN ie_platform_p='W' THEN 'Wheb'                                         WHEN ie_platform_p='T' THEN 'TWS'  ELSE trim(both expressao_pck.obter_dic_expressao_loc(489459,ds_locale_user_w)) END
                                        
      into STRICT nm_platform_w
;

    DS_TEXT := trim(both expressao_pck.obter_dic_expressao_loc(968490,ds_locale_user_w));
    DS_TEXT := replace(ds_text, '#@REQUESTER#@', nm_usuario_p);
    ds_text := replace(ds_text, '#@VERSION#@', cd_version_p);
    ds_text := replace(ds_text, '#@PLATFORM#@', nm_platform_w);
    ds_text := replace(ds_text, '#@CUSTOM_BRANCH#@', branch_name_p);

    insert into MAN_ORDEM_SERV_TECNICO(NR_SEQUENCIA,
          NR_SEQ_ORDEM_SERV,
          DT_ATUALIZACAO,
          NM_USUARIO,
          DT_HISTORICO,
          DT_LIBERACAO,
          NR_SEQ_TIPO,
          IE_ORIGEM,
          DS_RELAT_TECNICO)
          values (nextval('man_ordem_serv_tecnico_seq'),
          nr_sequence_so_p,
          clock_timestamp(),
          'Tasy',
          clock_timestamp(),
          clock_timestamp(),
          7,
          'I',
          DS_TEXT);
  end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ins_hist_request_build_so (nr_sequence_so_p bigint, cd_version_p text, ie_platform_p text, nm_usuario_p text, branch_name_p text) FROM PUBLIC;
