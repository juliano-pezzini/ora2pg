-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_variacao_sv ( nr_seq_item_suep_p bigint, nr_atendimento_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE

 
 
dt_ultima_w		timestamp;			
dt_penultima_w		timestamp;

vl_ultima_w		double precision;
vl_penultima_w		double precision;

qt_variacao_w		double precision;


BEGIN 
 
select 	max(c.dt_informacao) 
into STRICT	dt_ultima_w 
from 	w_suep a, 
	w_suep_item b, 
	w_suep_item_data c 
where  b.nr_seq_suep = a.nr_sequencia 
and   b.nr_sequencia = c.nr_seq_suep_item 
and   a.nr_atendimento = nr_atendimento_p 
and   a.nm_usuario = nm_usuario_p 
and   b.ie_grupo_suep = 'SV' 
and   c.nr_seq_suep_item = nr_seq_item_suep_p;
 
 
 
if (dt_ultima_w IS NOT NULL AND dt_ultima_w::text <> '') then 
 
	select 	max(c.dt_informacao) 
	into STRICT	dt_penultima_w 
	from 	w_suep a, 
		w_suep_item b, 
		w_suep_item_data c 
	where  b.nr_seq_suep = a.nr_sequencia 
	and   b.nr_sequencia = c.nr_seq_suep_item 
	and   a.nr_atendimento = nr_atendimento_p 
	and   a.nm_usuario = nm_usuario_p 
	and   b.ie_grupo_suep = 'SV' 
	and   c.nr_seq_suep_item = nr_seq_item_suep_p 
	and	c.dt_informacao <> dt_ultima_w;
	 
	if (dt_ultima_w IS NOT NULL AND dt_ultima_w::text <> '') and (dt_penultima_w IS NOT NULL AND dt_penultima_w::text <> '') then 
	 
		select	max(vl_informacao) 
		into STRICT	vl_penultima_w 
		from 	w_suep a, 
			w_suep_item b, 
			w_suep_item_data c 
		where  b.nr_seq_suep = a.nr_sequencia 
		and   b.nr_sequencia = c.nr_seq_suep_item 
		and   a.nr_atendimento = nr_atendimento_p 
		and   a.nm_usuario = nm_usuario_p 
		and   b.ie_grupo_suep = 'SV' 
		and   c.nr_seq_suep_item = nr_seq_item_suep_p 
		and	c.dt_informacao = dt_penultima_w;	
		 
		select	max(vl_informacao) 
		into STRICT	vl_ultima_w 
		from 	w_suep a, 
			w_suep_item b, 
			w_suep_item_data c 
		where  b.nr_seq_suep = a.nr_sequencia 
		and   b.nr_sequencia = c.nr_seq_suep_item 
		and   a.nr_atendimento = nr_atendimento_p 
		and   a.nm_usuario = nm_usuario_p 
		and   b.ie_grupo_suep = 'SV' 
		and   c.nr_seq_suep_item = nr_seq_item_suep_p 
		and	c.dt_informacao = dt_ultima_w;
 
		if (vl_penultima_w IS NOT NULL AND vl_penultima_w::text <> '') and (vl_ultima_w IS NOT NULL AND vl_ultima_w::text <> '') then 
			qt_variacao_w	:= vl_ultima_w - vl_penultima_w;
		end if;
 
	end if;
		 
 
	 
 
 
end if;
 
 
return	qt_variacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_variacao_sv ( nr_seq_item_suep_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

