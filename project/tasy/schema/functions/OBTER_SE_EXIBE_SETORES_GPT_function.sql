-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_setores_gpt ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_opcao_p text, ie_informacao_p text, ds_setores_p text) RETURNS varchar AS $body$
DECLARE


ie_alta_w	varchar(1) := 'N';
ds_setor_atendimento_w varchar(100);
ie_setor_valido_w varchar(1) := 'N';
ds_lista_w		varchar(1000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
ie_setor_w		varchar(10);
ds_setor_descricao_w varchar(100);

c01 CURSOR FOR
        SELECT     x.cd_registro cd_setor_atendimento
        from     table(lista_pck.obter_lista_char(ds_setores_p,',')) x;
BEGIN	
  if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
      ie_setor_valido_w := 'N';
      ds_setor_atendimento_w := substr(obter_unidade_atendimento(nr_atendimento_p,'IAA','S'),1,255);
      ds_lista_w := ds_setores_p;
      if (substr(ds_lista_w,length(ds_lista_w) - 1, length(ds_lista_w))	<> ',') then
	    ds_lista_w	:= ds_lista_w ||',';
      end if;

        for c01_w in c01 loop
            begin
            SELECT  max(ds_setor_atendimento) 
            INTO STRICT    ds_setor_descricao_w
            FROM	setor_atendimento 
            WHERE   ie_situacao = 'A' and cd_setor_atendimento = (c01_w.cd_setor_atendimento)::numeric 
            ORDER BY  ds_setor_atendimento;

            if (ds_setor_atendimento_w = ds_setor_descricao_w) then
                ie_setor_valido_w := 'S';
                exit;
            end if;
            end;
        end loop;

    return ie_setor_valido_w;
    end if;

  return ie_alta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_setores_gpt ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, ie_opcao_p text, ie_informacao_p text, ds_setores_p text) FROM PUBLIC;
