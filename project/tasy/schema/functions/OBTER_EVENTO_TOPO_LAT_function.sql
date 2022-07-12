-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_evento_topo_lat (nr_sequencia_p topografia_lat_adm.NR_SEQUENCIA%type) RETURNS varchar AS $body$
DECLARE


  ds_topo_lat_w topografia_lat_adm.DS_TOPO_LATERALIDADE%type;


BEGIN
  if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
    select  substr(max(ds_topo_lateralidade),1,255) a
    into STRICT    ds_topo_lat_w
    from    topografia_lat_adm a,
            prescr_mat_alteracao_comp b
    where a.nr_sequencia = b.nr_seq_topo_lat
    and   b.nr_sequencia_prescr = nr_sequencia_p;
  end if;

  return	ds_topo_lat_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_evento_topo_lat (nr_sequencia_p topografia_lat_adm.NR_SEQUENCIA%type) FROM PUBLIC;

