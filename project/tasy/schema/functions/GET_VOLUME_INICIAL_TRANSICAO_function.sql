-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_volume_inicial_transicao (nr_sequencia_interface_p bigint, nr_seq_transicao_p bigint) RETURNS bigint AS $body$
DECLARE

volume_ini_transicao_w	         bomba_infusao_transicao.qt_volume%type;
volume_ini_interface_w	         bomba_infusao_interface.qt_volume%type;

BEGIN

    BEGIN
				
				
				if (nr_seq_transicao_p = 999999999) THEN
				select qt_volume_inicial
				  into STRICT volume_ini_interface_w
				  from bomba_infusao_interface
						where nr_sequencia = nr_sequencia_interface_p;
				
				else
							
				select coalesce(qt_volume,0) 
				  into STRICT volume_ini_transicao_w 
						from bomba_infusao_transicao
				 where nr_Seq_bomba_interface = nr_sequencia_interface_p 
				   and nr_sequencia = nr_Seq_transicao_p;
				end if;

    EXCEPTION
        WHEN no_data_found THEN volume_ini_transicao_w := coalesce(volume_ini_interface_w,0);
    END;

RETURN	volume_ini_transicao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_volume_inicial_transicao (nr_sequencia_interface_p bigint, nr_seq_transicao_p bigint) FROM PUBLIC;
