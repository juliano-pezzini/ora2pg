-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_desfecho (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

						
qt_reg_w bigint;
ie_tipo_desfecho_w	varchar(1);
ie_param_28_w varchar(2);
ie_tipo_desfecho_alta_w varchar(2);
						

BEGIN

ie_param_28_w := obter_param_usuario(935, 28, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_param_28_w);

	select max(ie_desfecho)
	into STRICT ie_tipo_desfecho_w
	from atendimento_alta
	where nr_sequencia = nr_sequencia_p;



	if (ie_tipo_desfecho_w <> 'T') then
	
		select  count(1)
		into STRICT	qt_reg_w
		from	atendimento_alta
		where   nr_atendimento = (SELECT max(nr_atendimento) from atendimento_alta where nr_sequencia = nr_sequencia_p)
		and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and     coalesce(dt_inativacao::text, '') = ''
		and		ie_desfecho <> 'T'
		and		ie_tipo_orientacao = 'P';

    select count(1)
    into STRICT ie_tipo_desfecho_alta_w
    from	atendimento_alta
    where   nr_atendimento = (SELECT max(nr_atendimento) from atendimento_alta where nr_sequencia = nr_sequencia_p)
    and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	  and     coalesce(dt_inativacao::text, '') = ''
    and ie_desfecho = 'A'
    and ie_tipo_desfecho_w = 'A'
    and ie_param_28_w = 'S';
		
		if (ie_tipo_desfecho_alta_w <> qt_reg_w and qt_reg_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(108771);
		end if;
		
	end if;
	
	update	atendimento_alta
	set 	dt_liberacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_desfecho (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

