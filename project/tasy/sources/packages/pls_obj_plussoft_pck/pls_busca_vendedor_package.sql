-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_obj_plussoft_pck.pls_busca_vendedor ( nr_sequencia_p bigint, ie_status_pessoa_p text) RETURNS bigint AS $body$
DECLARE


/* Status de venda
ie_status_pessoa_p
'L' = Lead
'PA' - Proposta de adesao
'P' - Prospect
'C' - Cliente
*/
cd_pessoa_vendedor_w  pessoa_fisica.cd_pessoa_fisica%type;

BEGIN
if (ie_status_pessoa_p = 'L') then
  select  cd_pessoa_fisica
  into STRICT   cd_pessoa_vendedor_w
  from    pls_vendedor
  where   nr_sequencia = (SELECT  max(b.nr_seq_vendedor_canal)
          FROM pls_solicitacao_comercial a
LEFT OUTER JOIN pls_solicitacao_vendedor b ON (a.nr_sequencia = b.nr_seq_solicitacao)
WHERE a.nr_sequencia = nr_sequencia_p and clock_timestamp() between coalesce(b.dt_inicio_vigencia,clock_timestamp()) and coalesce(b.dt_fim_vigencia,clock_timestamp()) );
elsif (ie_status_pessoa_p = 'P') then
  select  cd_pessoa_fisica
  into STRICT   cd_pessoa_vendedor_w
  from    pls_vendedor
  where   nr_sequencia = ( 	SELECT	max(nr_seq_vendedor_canal)
							from	pls_solicitacao_vendedor x
							where	x.nr_seq_cliente	=nr_sequencia_p
							and   clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp()));
elsif (ie_status_pessoa_p = 'PA') then
  select  cd_pessoa_fisica
  into STRICT   cd_pessoa_vendedor_w
  from    pls_vendedor
  where   nr_sequencia = ( 	SELECT	max(nr_seq_vendedor_canal)
							from	pls_proposta_adesao x
							where	x.nr_sequencia	=nr_sequencia_p);
		
elsif (ie_status_pessoa_p = 'C') then
  select  cd_pessoa_fisica
  into STRICT   cd_pessoa_vendedor_w
  from    pls_vendedor
  where   nr_sequencia = (SELECT max(a.nr_seq_vendedor_canal)
						  from	 pls_segurado a
						  where  a.nr_sequencia = nr_sequencia_p);
end if;

return  cd_pessoa_vendedor_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_obj_plussoft_pck.pls_busca_vendedor ( nr_sequencia_p bigint, ie_status_pessoa_p text) FROM PUBLIC;