-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_formacao_plano_seg ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE

/*Criado para obter a Descrição da formação de preço do segurado*/

ds_retorno_w      varchar(255);
nr_seq_plano_w      bigint;
ie_preco_w      varchar(2);
ds_tipo_repasse_w    varchar(60);


BEGIN

if (coalesce(nr_seq_segurado_p,0)> 0) then

  begin
    select  nr_seq_plano,
		substr(obter_valor_dominio(3384,ie_tipo_repasse),1,60)
    into STRICT  nr_seq_Plano_w,
		ds_tipo_repasse_w
    from  pls_segurado
    where   nr_sequencia = nr_seq_segurado_p;
  exception
  when others then
    nr_seq_plano_w := null;
    ds_retorno_w := '';
  end;
  if (coalesce(nr_seq_plano_w,0) > 0) then
    if (coalesce(ds_tipo_repasse_w::text, '') = '') then
		select  ie_preco
		into STRICT  ie_preco_w
		from  pls_plano
		where  nr_sequencia    = nr_seq_plano_w;

      if (coalesce(ie_preco_w,'X') <> 'X') then
        begin
			select   substr(ds_valor_dominio,1,60) ds
			into STRICT  ds_retorno_w
			from   valor_dominio_v
			where   cd_dominio = 1669
			and  vl_dominio = ie_preco_w;
        exception
        when others then
			ds_retorno_w := '';
        end;
      else
			ds_retorno_w := '';
      end if;
    else
		ds_retorno_w := ds_tipo_repasse_w;
    end if;
  end if;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_formacao_plano_seg ( nr_seq_segurado_p bigint) FROM PUBLIC;

