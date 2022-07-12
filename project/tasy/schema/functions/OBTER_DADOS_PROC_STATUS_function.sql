-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_proc_status ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
	'U' - nm_usuario
	'D' - dt_atualizacao
	'S' - sequencia
	'I' - nr_seq_status_exec
*/
nm_usuario_w		varchar(15);
dt_atualizacao_w	timestamp;
nr_sequencia_w		bigint;
ie_status_exec_w 	varchar(3);
ie_ultimo_status_w	varchar(3);


BEGIN

nm_usuario_w := '';
dt_atualizacao_w := null;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from 	prescr_proc_status
	where	nr_prescricao		= nr_prescricao_p
	  and	nr_seq_prescr	= nr_Seq_prescr_p
	  and	ie_status_exec = ie_status_p;


	select ie_status_exec
	into STRICT   ie_ultimo_status_w
	from prescr_proc_status
	where nr_sequencia = (  SELECT max(nr_sequencia)
							from prescr_proc_status
							where nr_prescricao = nr_prescricao_p
							and   nr_seq_prescr = nr_seq_prescr_p);


	if (ie_status_p <= ie_ultimo_status_w) then

		if (nr_sequencia_w > 0) and (ie_opcao_p <> 'S') then
			select	coalesce(max(nm_usuario),''),
				coalesce(max(dt_atualizacao), null),
				coalesce(max(ie_status_exec),null)
			into STRICT	nm_usuario_w,
				dt_atualizacao_w,
				ie_status_exec_w
			from 	prescr_proc_status
			where	nr_prescricao		= nr_prescricao_p
			  and	nr_seq_prescr	= nr_Seq_prescr_p
			  and	ie_status_exec = ie_status_p
			  and 	nr_sequencia		= nr_sequencia_w;
		end if;

		if (ie_opcao_p = 'U') then
			return nm_usuario_w;
		elsif (ie_opcao_p = 'D') then
			return to_char(dt_atualizacao_W, 'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p = 'S') then
			return nr_sequencia_w;
		elsif (ie_opcao_p = 'I') then
			return ie_status_exec_w;
		end if;

	else
		return '0';
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_proc_status ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_p text, ie_opcao_p text) FROM PUBLIC;

