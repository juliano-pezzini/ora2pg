-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_prontuario ( NR_PRONTUARIO_P bigint, IE_OPCAO_P text) RETURNS varchar AS $body$
DECLARE


/* Opções
   C - Código
   D - Descricao */
ds_retorno_w    varchar(100);
cd_pessoa_fisica_w  varchar(100);
nm_pessoa_fisica_w  varchar(100);
ie_regra_pront_w    varchar(10);


BEGIN
if (NR_PRONTUARIO_P IS NOT NULL AND NR_PRONTUARIO_P::text <> '') then
  begin
  select  coalesce(max(vl_parametro),'BASE')
  into STRICT  ie_regra_pront_w
  from  funcao_parametro
  where  cd_funcao  = 0
  and  nr_sequencia  = 120;

  if (ie_regra_pront_w = 'BASE') or (ie_regra_pront_w = 'NUNCA') then

    select  cd_pessoa_fisica,
      substr(obter_nome_pf(cd_pessoa_fisica),1,100)
    into STRICT  cd_pessoa_fisica_w,
      nm_pessoa_fisica_w
    from  pessoa_fisica
    where  nr_prontuario  = NR_PRONTUARIO_P;
  elsif (ie_regra_pront_w = 'ESTAB')then
      select  cd_pessoa_fisica,
      substr(obter_nome_pf(cd_pessoa_fisica),1,100)
      into STRICT  cd_pessoa_fisica_w,
      nm_pessoa_fisica_w
      from  pessoa_fisica_pront_estab
      where  NR_PRONTUARIO  = nr_prontuario_p
      and  cd_estabelecimento  = wheb_usuario_pck.get_cd_estabelecimento;
  end if;
  if (ie_opcao_p = 'C') then
    ds_retorno_w   := cd_pessoa_fisica_w;
  elsif (ie_opcao_p = 'D') then
    ds_retorno_w   := nm_pessoa_fisica_w;
  else
    ds_retorno_w  := wheb_mensagem_pck.get_texto(795786);
  end if;
  end;
end if;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_prontuario ( NR_PRONTUARIO_P bigint, IE_OPCAO_P text) FROM PUBLIC;

