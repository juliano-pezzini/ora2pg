-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_qt_defeito (nr_seq_ordem_p bigint) RETURNS bigint AS $body$
DECLARE


ie_continua_w 	varchar(1);
ie_qtd_os_w 	smallint;
nr_os_defeito_w man_ordem_servico.nr_sequencia%TYPE;
nr_os_w         man_ordem_servico.nr_sequencia%TYPE;


BEGIN

ie_continua_w := 'S';
ie_qtd_os_w := 0;
nr_os_w := nr_seq_ordem_p;
if (coalesce(nr_seq_ordem_p,0) > 0) then
  while coalesce(ie_continua_w,'N') = 'S'
  loop
    begin
    select c.nr_seq_ordem_origem
      into STRICT nr_os_defeito_w
      from man_ordem_servico y,
           MAN_DOC_ERRO c
     where 1=1
     and c.nr_seq_ordem = y.nr_sequencia
     and y.ie_classificacao = 'E'
     and y.IE_STATUS_ORDEM =3
     and y.NR_SEQ_ESTAGIO = 9
     and y.nr_sequencia = nr_os_w;

     ie_qtd_os_w := ie_qtd_os_w+1;

    exception
        when no_data_found then ie_continua_w := 'N';
        when too_many_rows then ie_continua_w := 'N';
        when others then ie_continua_w := 'N';
    end;
    nr_os_w := nr_os_defeito_w;
  end loop;
end if;

return ie_qtd_os_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_qt_defeito (nr_seq_ordem_p bigint) FROM PUBLIC;
