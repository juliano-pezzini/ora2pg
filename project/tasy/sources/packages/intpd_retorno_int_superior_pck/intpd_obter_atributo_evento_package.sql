-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION intpd_retorno_int_superior_pck.intpd_obter_atributo_evento ( nr_seq_evento_p bigint) RETURNS SETOF T_ATRIBUTO AS $body$
DECLARE


r_atributo_row_w	r_atributo_row;
ie_evento_w		intpd_eventos.ie_evento%type;
ie_evento_sup_w		intpd_eventos.ie_evento%type;
nr_seq_evento_w		intpd_evento_superior.nr_seq_evento%type;
nr_seq_evento_sup_w	intpd_evento_superior.nr_seq_evento_sup%type;


BEGIN

select	a.nr_seq_evento,
	a.nr_seq_evento_sup
into STRICT	nr_seq_evento_w,
	nr_seq_evento_sup_w
from	intpd_evento_superior a
where	a.nr_sequencia = nr_seq_evento_p;

select	ie_evento
into STRICT	ie_evento_w
from	intpd_eventos
where	nr_sequencia = nr_seq_evento_w;

select	ie_evento
into STRICT	ie_evento_sup_w
from	intpd_eventos
where	nr_sequencia = nr_seq_evento_sup_w;

if (ie_evento_w = '214') and (ie_evento_sup_w = '12')then	
	r_atributo_row_w.nm_atributo	:= 'CD_PESSOA_FISICA';
elsif (ie_evento_w = '148') and (ie_evento_sup_w = '180') then	
	r_atributo_row_w.nm_atributo	:= 'NR_SEQUENCIA';
elsif (ie_evento_w = '161') and (ie_evento_sup_w = '214') then	
	r_atributo_row_w.nm_atributo	:= 'NR_ATENDIMENTO';	
	
end if;

RETURN NEXT r_atributo_row_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION intpd_retorno_int_superior_pck.intpd_obter_atributo_evento ( nr_seq_evento_p bigint) FROM PUBLIC;
