-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lib_gas_hor_gpt ( ie_tipo_usuario_p text, nm_tabela_p text, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE

  ie_liberacao_w  varchar(1) := 'N';
  nr_prescricao_w bigint;

BEGIN
  nr_prescricao_w := obter_prescr_item_cpoe(nr_seq_item_p,cpoe_obter_tipo_item(nm_tabela_p,nr_seq_item_p));

  if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then
    begin
      select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	  into STRICT ie_liberacao_w
      from cpoe_gasoterapia
      where ((ie_tipo_usuario_p = 'E'
      and coalesce(dt_liberacao_enf::text, '') = '')
      or (ie_tipo_usuario_p     = 'F'
      and coalesce(dt_liberacao_farm::text, '') = ''
      and (dt_liberacao_enf IS NOT NULL AND dt_liberacao_enf::text <> '')))
      and nr_sequencia          = nr_seq_item_p;

    end;
  end if;

return ie_liberacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lib_gas_hor_gpt ( ie_tipo_usuario_p text, nm_tabela_p text, nr_seq_item_p bigint) FROM PUBLIC;

