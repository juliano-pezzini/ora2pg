-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pac_clereance_creat_befins ON pac_clereance_creatinina CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pac_clereance_creat_befins() RETURNS trigger AS $BODY$
declare
  EXEC_W                     varchar(300);
  vl_mult_w                  double precision;
  vl_mult_mdrd_w             double precision;
  vl_mult_negro_w            double precision;
  vl_const_schwartz_w        double precision;	
  qt_superf_corporea_bb_w    double precision;	
  cd_estabelecimento_w       bigint;
  ie_formula_sup_corporea_w  varchar(10);
  nr_dec_sc_w                bigint;
  qt_reg_w	                 smallint;
BEGIN
  BEGIN
  if (NEW.nr_atendimento is not null) and (NEW.cd_pessoa_fisica is null) then
    NEW.cd_pessoa_fisica := obter_pessoa_atendimento(NEW.nr_atendimento,'C');
  end if;

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
    goto Final;
  end if;
  if (NEW.qt_idade is null) then
    select	(coalesce(max(obter_idade_pf(NEW.cd_pessoa_fisica, LOCALTIMESTAMP, 'A')),0))::numeric
    into STRICT	NEW.qt_idade
;
  end if;

  if (NEW.ie_raca_negra is null) then
    select	coalesce(max(ie_negro),'N')
    into STRICT	NEW.ie_raca_negra
    from	cor_pele a,
      pessoa_fisica b
    where	b.nr_seq_cor_pele = a.nr_sequencia
    and	b.cd_pessoa_fisica = NEW.cd_pessoa_fisica;
  end if;

  select	coalesce(CASE WHEN max(NEW.ie_raca_negra)='S' THEN 1.210 WHEN max(NEW.ie_raca_negra)='N' THEN 1 END ,1)
  into STRICT	vl_mult_negro_w	
;

  select coalesce(CASE WHEN obter_sexo_pf(NEW.cd_pessoa_fisica,'C')='F' THEN 0.85  ELSE 1 END ,1),
        coalesce(CASE WHEN obter_sexo_pf(NEW.cd_pessoa_fisica,'C')='F' THEN 0.742  ELSE 1 END ,1)
  into STRICT   vl_mult_w,
        vl_mult_mdrd_w
;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_CONST_SCHWARTZ_MD(:1,:2,:3) INTO :result';

    EXECUTE EXEC_W USING IN NEW.ie_rn_pre_termo,
                                   IN NEW.qt_idade,
                                   IN obter_sexo_pf(NEW.cd_pessoa_fisica,'C'),
                                   OUT vl_const_schwartz_w;
  exception
    when others then
      vl_const_schwartz_w := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_COCKCRIFT_GAULT_MD(:1,:2,:3,:4) INTO :result';

    EXECUTE EXEC_W USING IN NEW.qt_idade,
                                   IN NEW.qt_peso,
                                   IN NEW.qt_creatinina_serica,
                                   IN vl_mult_w,
                                   OUT NEW.qt_cockcroft_gault;
  exception
    when others then
      NEW.qt_cockcroft_gault := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_MDRD_MD(:1,:2,:3,:4) INTO :result';

    EXECUTE EXEC_W USING IN NEW.qt_creatinina_serica,
                                   IN NEW.qt_idade,
                                   IN vl_mult_mdrd_w,
                                   IN vl_mult_negro_w,
                                   OUT NEW.qt_mdrd;
  exception
    when others then
      NEW.qt_mdrd := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_SCHWARTZ_MD(:1,:2,:3) INTO :result';

    EXECUTE EXEC_W USING IN vl_const_schwartz_w,
                                   IN NEW.qt_altura_cm,
                                   IN NEW.qt_creatinina_serica,
                                   OUT NEW.qt_schwartz;
  exception
    when others then
      NEW.qt_schwartz := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_COUNHAHAN_BARRATT_MD(:1,:2) INTO :result';

    EXECUTE EXEC_W USING IN NEW.qt_altura_cm,
                                   IN NEW.qt_creatinina_serica,
                                   OUT NEW.qt_counhahan_barratt;
  exception
    when others then
      NEW.qt_counhahan_barratt := null;
  end;

  cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

  BEGIN
    select coalesce(coalesce('D',max(ie_formula_sup_corporea)),'M'),
          max(nr_dec_sc)
    into STRICT   ie_formula_sup_corporea_w,
          nr_dec_sc_w
    from   parametro_medico
    where  cd_estabelecimento = cd_estabelecimento_w;
    exception
    when others then
      ie_formula_sup_corporea_w := null;
      nr_dec_sc_w               := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_SUPERF_CORPOREA_BB_MD(:1,:2,:3,:4) INTO :result';

    EXECUTE EXEC_W USING IN NEW.qt_altura_cm,
                                   IN NEW.qt_peso,
                                   IN ie_formula_sup_corporea_w,
                                   IN nr_dec_sc_w,
                                   OUT qt_superf_corporea_bb_w;
  exception
    when others then
      qt_superf_corporea_bb_w := null;
  end;

  BEGIN
    EXEC_W := 'CALL PAC_CLEREANCE_CR_BEF_MD_PCK.OBTER_JELLIFFE_MD(:1,:2,:3,:4) INTO :result';

    EXECUTE EXEC_W USING IN NEW.qt_idade,
                                   IN NEW.qt_creatinina_serica,
                                   IN qt_superf_corporea_bb_w,
                                   IN obter_sexo_pf(NEW.cd_pessoa_fisica,'C'),
                                   OUT NEW.qt_jelliffe;
  exception
    when others then
      NEW.qt_jelliffe := null;
  end;

  <<Final>>
  qt_reg_w	:= 0;
    END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pac_clereance_creat_befins() FROM PUBLIC;

CREATE TRIGGER pac_clereance_creat_befins
	BEFORE INSERT OR UPDATE ON pac_clereance_creatinina FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pac_clereance_creat_befins();
