-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_dados_chamada_externa (p_nr_seq_regra regra_chamada_acesso.nr_seq_regra%type, p_cd_funcao_tasy regra_chamada_params.cd_funcao_tasy%type, p_nr_atendimento bigint default null, p_cd_pessoa_fisica text default null, p_cd_material bigint default null, p_cd_estabelecimento regra_chamada_acesso.cd_estabelecimento%type default null, p_cd_perfil regra_chamada_acesso.cd_perfil%type default null, p_nm_usuario_regra regra_chamada_acesso.nm_usuario_regra%type default null, p_ie_type_return_p text default 'P') RETURNS varchar AS $body$
DECLARE

  --  ie_type_return_p 
  --  'P' = Program 
  --  'U' = URL 
  c_macro CURSOR FOR
    SELECT mp.nr_sequencia,
           mp.nm_macro,
           mp.ds_sql
      from regra_chamada_externa rce, 
           regra_chamada_params  rcp,
           regra_chamada_macro  rcm,
           macro_prontuario      mp
     where rce.nr_sequencia   = rcp.nr_seq_regra
       and rce.nr_sequencia = rcm.nr_seq_regra
       and rcm.nr_sequencia_macro = mp.nr_sequencia
       and rce.nr_sequencia   = p_nr_seq_regra
       and rcp.cd_funcao_tasy = p_cd_funcao_tasy
       and (mp.ds_sql IS NOT NULL AND mp.ds_sql::text <> '')
       order by nr_sequencia_envio;

  w_ds_programa_externo     varchar(2000) := null;
  w_ds_url                  varchar(2000) := null;
  w_ds_retorno_macro        varchar(2000) := null;
  w_ie_tipo_chamada_externa varchar(1);
  w_nr_sequencia_macro      bigint;
  w_nm_macro                varchar(50);
  w_ds_sql_macro            varchar(2000);
  w_ds_sql_macro_alterado   varchar(2000);
  w_ds_valor_macro          varchar(2000);


BEGIN

  select rce.ds_programa_externo,
         rce.ds_url,
         rce.ie_tipo_chamada_externa
  into STRICT w_ds_programa_externo,
       w_ds_url,
       w_ie_tipo_chamada_externa
  from regra_chamada_externa rce
  where rce.nr_sequencia = p_nr_seq_regra  LIMIT 1;

  if p_ie_type_return_p = 'P' then
    w_ds_retorno_macro := w_ds_programa_externo;
  else
        w_ds_retorno_macro := w_ds_url;
  end if;

  if ((trim(both w_ds_retorno_macro) IS NOT NULL AND (trim(both w_ds_retorno_macro))::text <> '')) then
    open c_macro;
    loop
    fetch c_macro into
        w_nr_sequencia_macro,
        w_nm_macro,
        w_ds_sql_macro;
    EXIT WHEN NOT FOUND; /* apply on c_macro */
        begin
            w_ds_sql_macro_alterado := w_ds_sql_macro;
            w_ds_valor_macro := null;

            if (p_nr_atendimento IS NOT NULL AND p_nr_atendimento::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':nr_atendimento', p_nr_atendimento, 1, 0, 'i'),1,2000);
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':vl_atributo'   , p_nr_atendimento, 1, 0, 'i'),1,2000);
            end if;

            if (p_cd_pessoa_fisica IS NOT NULL AND p_cd_pessoa_fisica::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':cd_pessoa_fisica', p_cd_pessoa_fisica, 1, 0, 'i'),1,2000);
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':vl_atributo'   , p_nr_atendimento, 1, 0, 'i'),1,2000);
            end if;

            if (p_cd_material IS NOT NULL AND p_cd_material::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':cd_material', p_cd_material, 1, 0, 'i'),1,2000);
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':vl_atributo'   , p_nr_atendimento, 1, 0, 'i'),1,2000);
            end if;

            if (p_cd_estabelecimento IS NOT NULL AND p_cd_estabelecimento::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':cd_estabelecimento', p_cd_estabelecimento, 1, 0, 'i'),1,2000);
            end if;

            if (p_cd_perfil IS NOT NULL AND p_cd_perfil::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':cd_perfil', p_cd_perfil, 1, 0, 'i'),1,2000);
            end if;

            if (p_nm_usuario_regra IS NOT NULL AND p_nm_usuario_regra::text <> '') then
                w_ds_sql_macro_alterado := substr(REGEXP_REPLACE(w_ds_sql_macro_alterado, ':nm_usuario', p_nm_usuario_regra, 1, 0, 'i'),1,2000);
            end if;

            BEGIN
               EXECUTE w_ds_sql_macro_alterado INTO STRICT w_ds_valor_macro;

               if (w_ds_valor_macro IS NOT NULL AND w_ds_valor_macro::text <> '') then
                 w_ds_retorno_macro := substr(replace(w_ds_retorno_macro, w_nm_macro, w_ds_valor_macro),1,2000);
               end if;
            EXCEPTION
               WHEN OTHERS THEN
               w_ds_retorno_macro := substr(replace(w_ds_retorno_macro, w_nm_macro, ''),1,2000);
            END;
        end;
    end loop;
    close c_macro;
  end if;

  return w_ds_retorno_macro;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_dados_chamada_externa (p_nr_seq_regra regra_chamada_acesso.nr_seq_regra%type, p_cd_funcao_tasy regra_chamada_params.cd_funcao_tasy%type, p_nr_atendimento bigint default null, p_cd_pessoa_fisica text default null, p_cd_material bigint default null, p_cd_estabelecimento regra_chamada_acesso.cd_estabelecimento%type default null, p_cd_perfil regra_chamada_acesso.cd_perfil%type default null, p_nm_usuario_regra regra_chamada_acesso.nm_usuario_regra%type default null, p_ie_type_return_p text default 'P') FROM PUBLIC;

