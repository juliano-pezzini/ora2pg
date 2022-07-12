-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
/* ################ End get_superior_os               ####################### */

/* ################ Start get_retro_os                ####################### */

	


CREATE OR REPLACE FUNCTION phi_ordem_servico_pck.get_retro_os (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) RETURNS MAN_ORDEM_SERVICO.NR_SEQUENCIA%TYPE AS $body$
DECLARE

	
	nr_seq_os_ant_w		man_ordem_servico.nr_sequencia%type;
	
	
BEGIN
	
		select	max(mos.nr_sequencia)
		into STRICT	nr_seq_os_ant_w
		from	man_ordem_servico mos
		where	mos.nr_seq_os_ant = nr_seq_ordem_serv_p;
		
		if (nr_seq_os_ant_w IS NOT NULL AND nr_seq_os_ant_w::text <> '') then
			begin
				return phi_ordem_servico_pck.get_retro_os(nr_seq_os_ant_w);
			end;
		end if;
		
		return nr_seq_ordem_serv_p;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_ordem_servico_pck.get_retro_os (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) FROM PUBLIC;
