-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bft_insert_patient_call ( ds_locale_p text, ds_type_p text, dt_event_p timestamp, nm_usuario_p text, cd_type_p text) AS $body$
DECLARE

                    
nr_atendimento_w        bigint;
atend_pac_chamado_w     atend_pac_chamado%rowtype;
nr_seq_atend_pac_w      bigint;


BEGIN

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from    unidade_atendimento
where	nm_leito_integracao = ds_locale_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

    atend_pac_chamado_w.nr_atendimento    := nr_atendimento_w;

    if (cd_type_p = '012') then  -- Cancellation of the last call
    
        select  coalesce(max(nr_sequencia),0)
        into STRICT    nr_seq_atend_pac_w
        from    atend_pac_chamado
        where   nr_atendimento = nr_atendimento_w
        and     coalesce(dt_atendimento::text, '') = '';

        update	atend_pac_chamado
        set     ds_observacao = ds_observacao || ' (' || ds_type_p || ') ',
                dt_atendimento = coalesce(dt_event_p,clock_timestamp()),
                nm_usuario_atend = nm_usuario_p
        where   nr_sequencia  = nr_seq_atend_pac_w;

    elsif (cd_type_p = '060') then
	
        select	coalesce(max(nr_sequencia),0)
        into STRICT    nr_seq_atend_pac_w
        from    atend_pac_chamado
        where   nr_atendimento = nr_atendimento_w
        and     coalesce(dt_atendimento::text, '') = '';

        update	atend_pac_chamado
        set     dt_atendimento = coalesce(dt_event_p,clock_timestamp()),
                nm_usuario_atend = nm_usuario_p
        where   nr_sequencia  = nr_seq_atend_pac_w;
		
    else
	
		select    nextval('atend_pac_chamado_seq')
		into STRICT    atend_pac_chamado_w.nr_sequencia
		;
		
		atend_pac_chamado_w.dt_atualizacao        := clock_timestamp();
		atend_pac_chamado_w.dt_atualizacao_nrec   := clock_timestamp();
		atend_pac_chamado_w.nm_usuario            := nm_usuario_p;
		atend_pac_chamado_w.nm_usuario_nrec       := nm_usuario_p;
		atend_pac_chamado_w.nm_usuario_nrec       := nm_usuario_p;
		atend_pac_chamado_w.nm_usuario_chamado    := nm_usuario_p;
		atend_pac_chamado_w.dt_chamado            := dt_event_p;
		atend_pac_chamado_w.ds_observacao         := ds_type_p;
		
		insert into atend_pac_chamado values (atend_pac_chamado_w.*);
    
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bft_insert_patient_call ( ds_locale_p text, ds_type_p text, dt_event_p timestamp, nm_usuario_p text, cd_type_p text) FROM PUBLIC;
