-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_solucao_evento_insert ON prescr_solucao_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_solucao_evento_insert() RETURNS trigger AS $BODY$
declare

cd_setor_atendimento_w		bigint;
nr_seq_atend_w			bigint;
nr_seq_tipo_w			bigint;
cd_perfil_w			    integer;
ie_todas_gp_w			varchar(2);
dt_medicao_w			timestamp;
nr_seq_derivado_w		prescr_procedimento.nr_seq_derivado%type;
ie_bomba_infusao_w		prescr_sol_perda_ganho.ie_bomba_infusao%type;
is_record_trans_w   	varchar(1);
json_data_w         	text;
ds_param_integration_w  varchar(500);
is_order_transmit_w 	varchar(1);
is_retrogrado_w 		varchar(1);
cd_establishment_w 		smallint;
ie_retrogrado_w cpoe_procedimento.ie_retrogrado%type;
nr_prescricao_w     san_reserva.nr_prescricao%type;
is_record_inf_w     varchar(1);

c01 CURSOR FOR
SELECT	nr_seq_tipo
from	prescr_sol_perda_ganho
where	ie_evento		= NEW.ie_alteracao
and	coalesce(ie_tipo_solucao,1)	= NEW.ie_tipo_solucao
and	coalesce(ie_gerar_evento_solucao,'S') = 'S'
and	((cd_material is null) or (cd_material in (	SELECT	a.cd_material
							from	prescr_material a
							where	a.nr_sequencia_solucao	= NEW.nr_seq_solucao
							and	a.nr_prescricao		= NEW.nr_prescricao)))
and	((cd_setor_Atendimento is null) or (cd_setor_Atendimento	= cd_setor_atendimento_w))
and	((cd_perfil is null) or (cd_perfil = cd_perfil_w))
and	((ie_bomba_infusao is null) or (ie_bomba_infusao = ie_bomba_infusao_w))
and	((coalesce(nr_seq_derivado,0) = 0) or (coalesce(ie_tipo_solucao,1) <> 3) or
    ((coalesce(ie_tipo_solucao,1) = 3) and (coalesce(nr_seq_derivado,nr_seq_derivado_w) = nr_seq_derivado_w)));
BEGIN
  BEGIN

if (NEW.ie_tipo_solucao = 3) and (NEW.nr_seq_procedimento is not null) then
	select	coalesce(max(nr_seq_derivado),0)
	into STRICT	nr_seq_derivado_w
	from	prescr_procedimento
	where	nr_prescricao = NEW.nr_prescricao
	and		nr_sequencia = NEW.nr_seq_procedimento;
end if;

if (NEW.ie_tipo_solucao = 1) then
	BEGIN
	update	prescr_solucao
	set	nr_seq_evento	= NEW.nr_sequencia
	where	nr_prescricao	= NEW.nr_prescricao
	and	nr_seq_solucao	= NEW.nr_seq_solucao;
	end;
	
	select	max(ie_bomba_infusao)
	into STRICT	ie_bomba_infusao_w
	from	prescr_solucao
	where	nr_prescricao	= NEW.nr_prescricao
	and		nr_seq_solucao	= NEW.nr_seq_solucao;
	
end if;

if (NEW.qt_volume_parcial is not null) and (NEW.nr_atendimento is not null) then
	
	ie_todas_gp_w := Obter_Param_Usuario(1113, 403, obter_perfil_ativo, NEW.nm_usuario, 0, ie_todas_gp_w);

	select	max(cd_setor_atendimento),
			max(cd_perfil_ativo)
	into STRICT	cd_setor_atendimento_w,
			cd_perfil_w
	from	prescr_medica
	where	nr_prescricao	= NEW.nr_prescricao;
	
	dt_medicao_w := NEW.dt_alteracao;

	if (ie_todas_gp_w = 'N') then
	
		select	max(nr_seq_tipo)
		into STRICT	nr_seq_tipo_w
		from	prescr_sol_perda_ganho
		where	ie_evento		= NEW.ie_alteracao
		and	coalesce(ie_tipo_solucao,1)	= NEW.ie_tipo_solucao
		and	coalesce(ie_gerar_evento_solucao,'S') = 'S'
		and	((cd_material is null) or (cd_material in (	SELECT	a.cd_material
									from	prescr_material a
									where	a.nr_sequencia_solucao	= NEW.nr_seq_solucao
									and	a.nr_prescricao		= NEW.nr_prescricao)))
		and	((cd_setor_Atendimento is null) or (cd_setor_Atendimento	= cd_setor_atendimento_w))
		and	((cd_perfil is null) or (cd_perfil = cd_perfil_w))
		and	((coalesce(nr_seq_derivado,0) = 0) or (coalesce(ie_tipo_solucao,1) <> 3) or
			((coalesce(ie_tipo_solucao,1) = 3) and (coalesce(nr_seq_derivado,nr_seq_derivado_w) = nr_seq_derivado_w)));
		
		if (nr_seq_tipo_w is not null) then
		
			select	nextval('atendimento_perda_ganho_seq')
			into STRICT	nr_seq_atend_w
			;
			
			insert into atendimento_perda_ganho(nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				nr_seq_tipo,
				qt_volume,
				ds_observacao,
				dt_medida,
				cd_setor_atendimento,
				ie_origem,
				dt_referencia,
				cd_profissional,
				ie_situacao,
				dt_liberacao,
				dt_apap,
				qt_ocorrencia,
				nr_seq_evento_adep)
			values (nr_seq_atend_w,
				NEW.nr_atendimento,
				LOCALTIMESTAMP,
				NEW.nm_usuario,
				nr_seq_tipo_w,
				coalesce(NEW.qt_volume_parcial, NEW.qt_vol_infundido),
				NEW.ds_observacao,
				coalesce(dt_medicao_w,LOCALTIMESTAMP),
				cd_setor_atendimento_w,
				'S',
				LOCALTIMESTAMP,
				NEW.cd_pessoa_fisica,
				'A',
				LOCALTIMESTAMP,
				coalesce(dt_medicao_w,LOCALTIMESTAMP),
				1,
				NEW.nr_sequencia);
		end if;
	else
		
		open C01;
		loop
		fetch C01 into	
			nr_seq_tipo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			
			select	nextval('atendimento_perda_ganho_seq')
			into STRICT	nr_seq_atend_w
			;
			
			insert into atendimento_perda_ganho(nr_sequencia,
				nr_atendimento,
				dt_atualizacao,
				nm_usuario,
				nr_seq_tipo,
				qt_volume,
				ds_observacao,
				dt_medida,
				cd_setor_atendimento,
				ie_origem,
				dt_referencia,
				cd_profissional,
				ie_situacao,
				dt_liberacao,
				dt_apap,
				qt_ocorrencia,
				nr_seq_evento_adep)
			values (nr_seq_atend_w,
				NEW.nr_atendimento,
				LOCALTIMESTAMP,
				NEW.nm_usuario,
				nr_seq_tipo_w,
				coalesce(NEW.qt_volume_parcial, NEW.qt_vol_infundido),
				NEW.ds_observacao,
				coalesce(dt_medicao_w,LOCALTIMESTAMP),
				cd_setor_atendimento_w,
				'S',
				LOCALTIMESTAMP,
				NEW.cd_pessoa_fisica,
				'A',
				LOCALTIMESTAMP,
				coalesce(dt_medicao_w,LOCALTIMESTAMP),
				1,
				NEW.nr_sequencia);
		end loop;
		close C01;
	end if;
	
end if;

if (NEW.ie_alteracao = '1') then
	BEGIN
		select CASE WHEN count(*)=1 THEN  'S'  ELSE 'N' END
		into STRICT   is_record_trans_w
		from   san_reserva_prod b
		where  b.nr_sequencia = NEW.nr_seq_prod_reserva
		and    b.ie_status = 'T';
		exception when others then
		is_record_trans_w := 'N';
		end;

        if NEW.nr_prescricao is null then
            select   coalesce(max(nr_prescricao), 0)
            into STRICT     nr_prescricao_w
            from     san_reserva
            where    nr_sequencia = NEW.nr_seq_reserva;
        else
            nr_prescricao_w := NEW.nr_prescricao;
        end if;

		if nr_prescricao_w <> 0 then

			select    coalesce(max(cd_estabelecimento), wheb_usuario_pck.get_cd_estabelecimento)
			into STRICT      cd_establishment_w
			from      prescr_medica
			where     nr_prescricao = nr_prescricao_w;

			BEGIN
				select  is_special_order_rule('TR','A',cd_establishment_w)
				into STRICT    is_order_transmit_w
				;
			exception when no_data_found then
				is_order_transmit_w := 'N';
			end;

			BEGIN
				select  coalesce(max(a.ie_retrogrado), 'N')
				into STRICT    is_retrogrado_w
				from    cpoe_hemoterapia a,
						prescr_procedimento b
				where   a.nr_sequencia = b.nr_seq_proc_cpoe
				and     b.nr_prescricao = nr_prescricao_w;
			exception when no_data_found then
				is_retrogrado_w := 'N';
			end;

			if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
				if wheb_usuario_pck.get_ie_executar_trigger	= 'S'  then
					if (is_record_trans_w = 'S' and (is_retrogrado_w = 'N' or (is_retrogrado_w = 'S' and is_order_transmit_w = 'S'))) then
						BEGIN
							ds_param_integration_w :=  '{"recordId" : "' || NEW.nr_sequencia|| '"' || '}';
							CALL execute_bifrost_integration(303, ds_param_integration_w);
						end;
					end if;
				end if;
			end if;
        end if;
	end if;

    if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then

        select  coalesce(max(c.ie_retrogrado), 'N'),
                CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END 
        into STRICT    ie_retrogrado_w,
                is_record_inf_w
        from    cpoe_order_unit a,
                cpoe_tipo_pedido b,
                cpoe_material c,
                cpoe_rp g
        where   b.nr_sequencia  = a.nr_seq_cpoe_tipo_pedido
        and     a.nr_sequencia  = c.nr_seq_cpoe_order_unit 
        and     c.nr_seq_cpoe_rp = g.nr_sequencia
        and     b.nr_seq_sub_grp    = 'I'
        and     c.ie_controle_tempo = 'S'
        and     c.nr_sequencia = NEW.nr_seq_cpoe;


		select  is_special_order_rule('IN','A',cd_establishment_w)
		into STRICT    is_order_transmit_w
		;
		
		if((is_record_inf_w = 'S') and (ie_retrogrado_w = 'N' or (ie_retrogrado_w = 'S' and is_order_transmit_w = 'S'))) then
			if (NEW.ie_alteracao in (1,6)) then
				ds_param_integration_w:='{"recordId" : "'||NEW.nr_sequencia||'"}';
				CALL execute_bifrost_integration(271, ds_param_integration_w);
			end if;
		end if;
    end if;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_solucao_evento_insert() FROM PUBLIC;

CREATE TRIGGER prescr_solucao_evento_insert
	AFTER INSERT ON prescr_solucao_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_solucao_evento_insert();

