-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nr_protocolo_atend ( nr_sequencia_p bigint, ie_tipo_origem_p bigint) RETURNS varchar AS $body$
DECLARE


nr_protocolo_atendimento_w	varchar(20);
nr_seq_atend_pls_w		pls_atendimento.nr_sequencia%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;

/*
	ie_tipo_origem_p
	1 - Requisição
	2 - Guia
	3 - Boletim de Ocorrência
	4 - Atendimento (call center)
	5 - Protocolo de atendimento (Sequência)
	10 - Portabilidade
*/
BEGIN

if (ie_tipo_origem_p = 1) then
	begin
		select	nr_protocolo
		into STRICT	nr_protocolo_atendimento_w
		from	pls_protocolo_atendimento
		where	nr_seq_requisicao = nr_sequencia_p;
	exception
	when others then
		nr_protocolo_atendimento_w	:= null;
	end;
	if (coalesce(nr_protocolo_atendimento_w::text, '') = '') then
		begin
			select	nr_seq_atend_pls
			into STRICT	nr_seq_atend_pls_w
			from	pls_requisicao
			where 	nr_sequencia	= nr_sequencia_p;
		exception
		when others then
			nr_seq_atend_pls_w	:= null;
		end;
		
		if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') then
			begin
				select	nr_protocolo
				into STRICT	nr_protocolo_atendimento_w
				from	pls_protocolo_atendimento
				where	nr_seq_atend_pls 	= nr_seq_atend_pls_w;
			exception
			when others then
				nr_protocolo_atendimento_w	:= null;
			end;
		end if;
	end if;
elsif (ie_tipo_origem_p = 2) then
	begin
		select	nr_protocolo
		into STRICT	nr_protocolo_atendimento_w
		from	pls_protocolo_atendimento
		where	nr_seq_guia	= nr_sequencia_p;
	exception
	when others then
		nr_protocolo_atendimento_w	:= null;
	end;
	if (coalesce(nr_protocolo_atendimento_w::text, '') = '') then
		begin
			select	nr_seq_atend_pls
			into STRICT	nr_seq_atend_pls_w
			from	pls_guia_plano
			where	nr_sequencia	= nr_sequencia_p;
		exception
		when others then
			nr_seq_atend_pls_w	:= null;
		end;
		if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') then
			begin
				select	nr_protocolo
				into STRICT	nr_protocolo_atendimento_w
				from	pls_protocolo_atendimento
				where	nr_seq_atend_pls	= nr_seq_atend_pls_w;
			exception
			when others then
				nr_protocolo_atendimento_w	:= null;
			end;
		end if;
		
		if (coalesce(nr_protocolo_atendimento_w::text, '') = '') then
			select	max(nr_seq_requisicao)
			into STRICT	nr_seq_requisicao_w
			from	pls_execucao_requisicao
			where	nr_seq_guia = nr_sequencia_p;
			
			begin
				select	nr_protocolo
				into STRICT	nr_protocolo_atendimento_w
				from	pls_protocolo_atendimento
				where	nr_seq_requisicao = nr_seq_requisicao_w;
			exception
			when others then
				nr_protocolo_atendimento_w	:= null;
			end;
			if (coalesce(nr_protocolo_atendimento_w::text, '') = '') then
				begin
					select	nr_seq_atend_pls
					into STRICT	nr_seq_atend_pls_w
					from	pls_requisicao
					where	nr_sequencia	= nr_seq_requisicao_w;
				exception
				when others then
					nr_seq_atend_pls_w	:= null;
				end;
				
				if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') then
					begin
						select	nr_protocolo
						into STRICT	nr_protocolo_atendimento_w
						from	pls_protocolo_atendimento
						where	nr_seq_atend_pls	= nr_seq_atend_pls_w;
					exception
					when others then
						nr_protocolo_atendimento_w	:= null;
					end;
				end if;
			end if;
		end if;
	end if;
elsif (ie_tipo_origem_p = 3) then
	begin
		select	nr_protocolo
		into STRICT	nr_protocolo_atendimento_w
		from	pls_protocolo_atendimento
		where	nr_seq_boletim_ocor = nr_sequencia_p;
	exception
	when others then
		nr_protocolo_atendimento_w	:= null;
	end;
	if (coalesce(nr_protocolo_atendimento_w::text, '') = '') then
		begin
			select	nr_atend_pls
			into STRICT	nr_seq_atend_pls_w
			from	sac_boletim_ocorrencia
			where 	nr_sequencia	= nr_sequencia_p;
		exception
		when others then
			nr_seq_atend_pls_w	:= null;
		end;
		if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') then
			begin
				select	nr_protocolo
				into STRICT	nr_protocolo_atendimento_w
				from	pls_protocolo_atendimento
				where	nr_seq_atend_pls	= nr_seq_atend_pls_w;
			exception
			when others then
				nr_protocolo_atendimento_w	:= null;
			end;
		end if;
	end if;
elsif (ie_tipo_origem_p = 4) then
	select	max(nr_protocolo)
	into STRICT	nr_protocolo_atendimento_w
	from	pls_protocolo_atendimento
	where	nr_seq_atend_pls = nr_sequencia_p;
elsif (ie_tipo_origem_p = 5) then
	select	max(nr_protocolo)
	into STRICT	nr_protocolo_atendimento_w
	from	pls_protocolo_atendimento
	where	nr_sequencia = nr_sequencia_p;
elsif (ie_tipo_origem_p = 10) then
	select	max(nr_protocolo)
	into STRICT	nr_protocolo_atendimento_w
	from	pls_protocolo_atendimento
	where	nr_seq_portabilidade = nr_sequencia_p;
end if;

return	nr_protocolo_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nr_protocolo_atend ( nr_sequencia_p bigint, ie_tipo_origem_p bigint) FROM PUBLIC;

