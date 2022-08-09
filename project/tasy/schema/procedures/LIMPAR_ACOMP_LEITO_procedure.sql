-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_acomp_leito (nr_atendimento_p bigint, cd_unid_basica_acomp_p text, cd_unide_compl_acomp_p text, cd_setor_atendimento_p bigint) AS $body$
DECLARE


    ie_alojamento_ww        varchar(1);
    nr_acompanhante_ww      integer;
    nr_seq_interno_acomp_ww bigint;

BEGIN
    if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select   max(nr_seq_interno)
	into STRICT	 nr_seq_interno_acomp_ww
	from	 unidade_atendimento
	where    nr_atendimento_acomp = nr_atendimento_p;

	if (nr_seq_interno_acomp_ww IS NOT NULL AND nr_seq_interno_acomp_ww::text <> '') then
	    update unidade_atendimento
	    set	   ie_status_unidade	= 'L',
		   nr_atendimento_acomp	 = NULL,
		   cd_paciente_reserva	 = NULL,
		   nm_pac_reserva	 = NULL,
		   nm_usuario		= user,
		   dt_atualizacao	= clock_timestamp()
	    where nr_seq_interno 	= nr_seq_interno_acomp_ww;
	end if;

	select coalesce(ie_alojamento, 'N') ie_alojamento
              ,nr_acompanhante
        into STRICT   ie_alojamento_ww
              ,nr_acompanhante_ww
        from   atendimento_acompanhante
        where  nr_atendimento  = nr_atendimento_p
        and  nr_acompanhante   = (SELECT max(nr_acompanhante)
                                  from   atendimento_acompanhante
                                  where  nr_atendimento = nr_atendimento_p);

        if (ie_alojamento_ww = 'S') then
            begin
                update atendimento_acompanhante
                set    ie_alojamento   = 'N',
		       dt_saida	        = NULL
                where  nr_atendimento  = nr_atendimento_p
                and  nr_acompanhante = nr_acompanhante_ww;
            end;
        end if;
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_acomp_leito (nr_atendimento_p bigint, cd_unid_basica_acomp_p text, cd_unide_compl_acomp_p text, cd_setor_atendimento_p bigint) FROM PUBLIC;
